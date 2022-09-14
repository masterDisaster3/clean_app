// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:clean_app/data/models/marker_model/marker_model.dart';
import 'package:clean_app/data/models/profile_model/profile.dart';
import 'package:clean_app/data/models/profile_model/profile_detail.dart';
import 'package:rxdart/rxdart.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:supabase/supabase.dart';

class Repository {
  /// Class that provides Supabase, Secure Storage, Location
  Repository({
    required SupabaseClient supabaseClient,
    required FlutterSecureStorage localStorage,
  })  : _supabaseClient = supabaseClient,
        _localStorage = localStorage {
    _setAuthListenner();
  }

  final SupabaseClient _supabaseClient;
  final FlutterSecureStorage _localStorage;

  Completer statusKnown = Completer();

  void _setAuthListenner() {
    _supabaseClient.auth.onAuthStateChange((event, session) {
      _resetCache();
    });
  }

  //USER MANAGEMENT: SIGN UP SIGN IN

  String? get userId => _supabaseClient.auth.currentUser?.id;

  Future<String> signUp({
    required String email,
    required String password,
  }) async {
    final res = await _supabaseClient.auth.signUp(email, password);
    final error = res.error;
    if (error != null) {
      throw PlatformException(code: 'signup error', message: error.message);
    }
    return res.data!.persistSessionString;
  }

  Future<String> signIn({
    required String email,
    required String password,
  }) async {
    final res =
        await _supabaseClient.auth.signIn(email: email, password: password);
    log(" From supabase sign in module: ${res.data!.toString()}");

    final error = res.error;
    if (error != null) {
      throw PlatformException(code: 'login error', message: error.message);
    }
    return res.data!.persistSessionString;
  }

  Future<bool> signOut() async {
    final res = await _supabaseClient.auth.signOut();

    await deleteSession();

    if (res.error != null) {
      return false;
    } else {
      return true;
    }
  }

  //SESSION MANAGMENT: RECOVER, DELETE
  static const _persistantSessionKey = 'supabase_session';
  bool _hasRefreshedSession = false;

  Future<void> deleteSession() {
    log("Delete session called");
    return _localStorage.delete(key: _persistantSessionKey);
  }

  Future<void> setSessionString(String sessionString) {
    log("Set session called with session string");
    return _localStorage.write(
        key: _persistantSessionKey, value: sessionString);
  }

  Future<void> _resetCache() async {
    log("repository._resetCache cache called");
    if (userId != null && !_hasRefreshedSession) {
      _hasRefreshedSession = true;
      profileDetailsCache.clear();
      await getMyProfile();
    }
  }

  Future<void> recoverSession() async {
    log("repository.recoverSession of called from Onresumed");

    final jsonStr = await _localStorage.read(key: _persistantSessionKey);

    log("repository.recoverSession This is json response from local storage:");

    if (jsonStr == null) {
      await deleteSession();

      if (!statusKnown.isCompleted) {
        statusKnown.complete();
      }
      return;
    }

    final res = await _supabaseClient.auth.recoverSession(jsonStr);

    log("repository.recoverSession This is response from supabase over json:");

    final error = res.error;
    if (error != null) {
      await deleteSession();
      if (!statusKnown.isCompleted) {
        statusKnown.complete();
      }

      throw PlatformException(code: 'login error', message: error.message);
    }

    final session = res.data;
    if (session == null) {
      await deleteSession();
      if (!statusKnown.isCompleted) {
        statusKnown.complete();
      }
      return;
    }
    await setSessionString(session.persistSessionString);
    await _resetCache();
  }

  //TERMS AND CONDITIONS MANAGMENT
  static const _termsOfServiceAgreementKey = 'agreed';
  Future<bool> get hasAgreedToTermsOfService =>
      _localStorage.containsKey(key: _termsOfServiceAgreementKey);

  Future<void> agreedToTermsOfService() =>
      _localStorage.write(key: _termsOfServiceAgreementKey, value: 'true');

  //PROFILE MANAGEMENT
  //ProfileDetail in cache memory

  Map<String, ProfileDetail> profileDetailsCache = {};

  Profile? get myProfile => profileDetailsCache[userId ?? ''];

  Completer<void> myProfileHasLoaded = Completer<void>();

  Future<Profile?> getMyProfile() async {
    log("repository.getMyProfile called from _resetCache");

    final userId = this.userId;
    if (userId == null) {
      throw PlatformException(code: 'not signed in ', message: 'Not signed in');
    }
    try {
      await getProfileDetail(userId);
      if (!myProfileHasLoaded.isCompleted) {
        myProfileHasLoaded.complete();
      }
    } catch (e) {
      log(e.toString());
    }
    if (!statusKnown.isCompleted) {
      statusKnown.complete();
    }
    return null;
  }

  // These are the stream things
  final _profileStreamController =
      BehaviorSubject<Map<String, ProfileDetail>>();
  // This emits the stream
  Stream<Map<String, ProfileDetail>> get profileStream =>
      _profileStreamController.stream;

  Future<void> getProfileDetail(String targetUid) async {
    log("repository.getProfileDetail called");
    if (profileDetailsCache[targetUid] != null) {
      return;
    }
    late final PostgrestResponse res;
    res = await _supabaseClient
        .rpc('profile_detail', params: {'my_user_id': targetUid}).execute();

    final error = res.error;
    if (error != null) {
      throw PlatformException(
        code: error.code ?? 'Database_Error',
        message: error.message,
      );
    }

    final data = res.data as List;

    //log("repository.getProfileDetail.data: $data");

    //log("repository.getProfileDetail.data: ${data[0]['locationscontributed']}");

    //var location = data[0]['locationscontributed'] as int ;

    if (data.isEmpty) {
      throw PlatformException(
        code: error?.code ?? 'No User',
        message: error?.message ?? 'Could not find the user. ',
      );
    }

    final profile = ProfileDetail.fromData(data[0] as Map<String, dynamic>);

    log("repository.getProfileDetail.profile $profile");

    profileDetailsCache[targetUid] = profile;
    _profileStreamController.sink.add(profileDetailsCache);
  }

  Future<void> saveProfile({required Profile profile}) async {
    final res =
        await _supabaseClient.from('users').upsert(profile.toMap()).execute();
    final data = res.data;
    final error = res.error;
    if (error != null) {
      throw PlatformException(
        code: error.code ?? 'Database_Error',
        message: error.message,
      );
    }
    if (data == null) {
      throw PlatformException(
        code: 'Database_Error',
        message: 'Error occured while saving profile',
      );
    }
    late final ProfileDetail newProfile;
    if (profileDetailsCache[userId!] != null) {
      newProfile = profileDetailsCache[userId!]!.copyWith(
        name: profile.name,
        bio: profile.bio,
        profilePictureUrl: profile.profilePictureUrl,
      );
    } else {
      log('When the user initially registered');
      _hasRefreshedSession = false;
      await _resetCache();
      newProfile = ProfileDetail(
        id: userId!,
        name: profile.name,
        bio: profile.bio,
        profilePictureUrl: profile.profilePictureUrl,
        locationsAltered: 0,
        locationsContributed: 0,
      );
    }
    profileDetailsCache[userId!] = newProfile;
    _profileStreamController.add(profileDetailsCache);
  }

  //MEDIA MANAGEMENT
  Future<String> uploadFile({
    required String bucket,
    required File file,
    required String path,
  }) async {
    final res = await _supabaseClient.storage.from(bucket).upload(path, file);
    final error = res.error;
    if (error != null) {
      throw PlatformException(
        code: error.error ?? 'uploadFile',
        message: error.message,
      );
    }
    final urlRes = _supabaseClient.storage.from(bucket).getPublicUrl(path);
    log("repository.uploadFile: $urlRes");
    final urlError = urlRes.error;
    if (urlError != null) {
      throw PlatformException(
        code: urlError.error ?? 'uploadFile',
        message: urlError.message,
      );
    }
    return urlRes.data!;
  }

  // deleteFile({
  //   required String bucket,
  //   required String path,
  // }) async {
  //   final res = await _supabaseClient.storage.from(bucket).remove([path]);

  //   log("Delete file : $path .... ${res.data.toString()}");
  //   final error = res.error;
  //   if (error != null) {
  //     throw PlatformException(
  //       code: error.error ?? 'deleteFile',
  //       message: error.message,
  //     );
  //   }
  // }

  //MARKER MANAGEMENT

  final List<CleanMarker> mapMarkers = [];
  final _mapMarkerStreamConntroller = BehaviorSubject<List<CleanMarker>>();

  Stream<List<CleanMarker>> get mapMarkersStream =>
      _mapMarkerStreamConntroller.stream;

  uploadMarker(CleanMarker cleanMarker) async {
    final res = await _supabaseClient
        .from('markers')
        .insert([cleanMarker.toMap()]).execute();
    final error = res.error;
    if (error != null) {
      throw PlatformException(
        code: error.code ?? 'uploadMarker',
        message: error.message,
      );
    }
    final data = res.data;

    //log("repository.uploadMarker: $data");
  }

  Future<void> getMarkers() async {
    log("repository:getMarkers called");

    final res = await _supabaseClient
        .from('markers')
        .select()
        .order('created_at')
        .execute();

    final error = res.error;
    if (error != null) {
      throw PlatformException(code: 'getMarkers error');
    }

    final data = res.data;

    if (data == null) {
      throw PlatformException(code: 'getMarkers error');
    }

    List<CleanMarker> cleanMarkers = CleanMarker.markersFromMap(data: data);

    mapMarkers.addAll(cleanMarkers);
    _mapMarkerStreamConntroller.sink.add(cleanMarkers);
  }

  final _userMarkerStreamConntroller = BehaviorSubject<List<CleanMarker>>();

  Stream<List<CleanMarker>> get userMarkersStream =>
      _userMarkerStreamConntroller.stream;

  Future<void> getUserMarkers(String userIdClean) async {
    log("repository:getUserMarkers called");

    final res = await _supabaseClient
        .from('markers')
        .select()
        .eq('user_id', userIdClean)
        .order('created_at')
        .execute();

    final error = res.error;
    if (error != null) {
      throw PlatformException(code: 'getUserMarkers error');
    }

    final data = res.data;

    if (data == null) {
      throw PlatformException(code: 'getUserMarkers error');
    }

    List<CleanMarker> cleanMarkers = CleanMarker.markersFromMap(data: data);

    _userMarkerStreamConntroller.sink.add(cleanMarkers);
  }

  Future<bool> deleteMapMarker(String markerId) async {
    log(markerId);

    try {
      final res =
          _supabaseClient.from('markers').delete().eq('id', markerId).execute();

      log(res.toString());
      return true;
    } catch (e) {
      throw PlatformException(code: 'deleteMapMarker error  $e');
    }
  }
}
