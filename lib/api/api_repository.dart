import 'dart:async';

import 'package:flutter/foundation.dart';
import 'dart:typed_data';
import 'package:sales/models/models.dart';
import 'package:sales/models/request/agent/submit_agent.dart';
import 'package:sales/models/request/attendance/attendance_wrapper.dart';
import 'package:sales/models/request/attendance/submit_attendance.dart';
import 'package:sales/models/request/attendance/validate_attenance.dart';
import 'package:sales/models/request/claim/detail_claim_request.dart';
import 'package:sales/models/request/claim/submit_claim_request.dart';
import 'package:sales/models/request/claim/update_approval_claim_request.dart';
import 'package:sales/models/request/cuti/submit_cuti_request.dart';
import 'package:sales/models/request/cuti/update_approval_request.dart';
import 'package:sales/models/request/cuti_sales/detail_request_cuti.dart';
import 'package:sales/models/request/cuti_sales/submit_izin_request.dart';
import 'package:sales/models/request/cuti_sales/update_approval_request.dart';
import 'package:sales/models/request/dashboard_request.dart';
import 'package:sales/models/request/detail_request.dart';
import 'package:sales/models/request/detail_request_leave.dart';
import 'package:sales/models/request/id_request.dart';
import 'package:sales/models/request/input_request.dart';
import 'package:sales/models/request/izin/submit_izin_request.dart';
import 'package:sales/models/request/izin/update_approval_request.dart';
import 'package:sales/models/request/kuisioner/kuisioner_input_data_request.dart';
import 'package:sales/models/request/kuisioner/kuisioner_request.dart';
import 'package:sales/models/request/kunjungan/non_schedule_request.dart';
import 'package:sales/models/request/leads/submit_lead.dart';
import 'package:sales/models/request/leads/submit_status_lead.dart';
import 'package:sales/models/request/lembur/detail_request_lembur.dart';
import 'package:sales/models/request/lembur/submit_izin_request.dart';
import 'package:sales/models/request/lembur/update_approval_request.dart';
import 'package:sales/models/request/logout_request.dart';
import 'package:sales/models/request/overtime/get_list.dart';
import 'package:sales/models/request/overtime/set_done_overtime_request.dart';
import 'package:sales/models/request/overtime/submit_overtime_client_request.dart';
import 'package:sales/models/request/overtime/submit_request_overtime.dart';
import 'package:sales/models/request/overtime/update_approval_overtime_request.dart';
import 'package:sales/models/request/pagination_request.dart';
import 'package:sales/models/request/payslip/download_payslip_request.dart';
import 'package:sales/models/request/prospek_v2/detail_request_cuti.dart';
import 'package:sales/models/request/prospek_v2/submit_request_prospek_v2.dart';
import 'package:sales/models/request/rate/submit_rate_request.dart';
import 'package:sales/models/request/reliver/approve_reliver_request.dart';
import 'package:sales/models/request/reliver/create_reliver_request.dart';
import 'package:sales/models/request/store/detail_request_leave.dart';
import 'package:sales/models/request/store/update_qty_request.dart';
import 'package:sales/models/request/submit_mood_request.dart';
import 'package:sales/models/request/shift_swap/detail_shift_swap_request.dart';
import 'package:sales/models/request/shift_swap/submit_shift_swap_request.dart';
import 'package:sales/models/request/shift_swap/update_approval_shift_swap_request.dart';
import 'package:sales/models/request/update_fcm_profile_request.dart';
import 'package:sales/models/request/update_photo_profile_request.dart';
import 'package:sales/models/request/user_id_request.dart';
import 'package:sales/models/response/Lead/list_lead_respone.dart';
import 'package:sales/models/response/agent/list_agent_response.dart';
import 'package:sales/models/response/attendance/attendance_submit.dart';
import 'package:sales/models/response/attendance/attendance_validate.dart';
import 'package:sales/models/response/benefit/benefit_dashboard_response.dart';
import 'package:sales/models/response/branch_response.dart';
import 'package:sales/models/response/benefit/show_benefit.dart';
import 'package:sales/models/response/benefit/type_cuti.dart';
import 'package:sales/models/response/cuti_sales/list_cuti_sales.dart';
import 'package:sales/models/response/cuti_sales/show_cuti_sales.dart';
import 'package:sales/models/response/dashboard/dashboard_kunjungan_response.dart';
import 'package:sales/models/response/izin/list_izin.dart';
import 'package:sales/models/response/izin/show_izin.dart';
import 'package:sales/models/response/izin/type_izin.dart';
import 'package:sales/models/response/kuisioner/input_data_kuisioner_respons.dart';
import 'package:sales/models/response/kuisioner_response.dart';
import 'package:sales/models/response/lembur/list_lembur.dart';
import 'package:sales/models/response/lembur/show_lembur.dart';
import 'package:sales/models/response/master_data_2_response.dart';
import 'package:sales/models/response/name_tad_list_response.dart';
import 'package:sales/models/response/claim/list_claim_response.dart';
import 'package:sales/models/response/claim/show_claim_response.dart';
import 'package:sales/models/response/payslip/payslip_download_result.dart';
import 'package:sales/models/response/payslip/payslip_list_response.dart';
import 'package:sales/models/response/prospek/list.dart';
import 'package:sales/models/response/prospek/master_data_response.dart';
import 'package:sales/models/response/prospek/master_id_response.dart';
import 'package:sales/models/response/shift_swap/list_shift_swap_response.dart';
import 'package:sales/models/response/shift_swap/show_shift_swap_response.dart';
import 'package:sales/models/response/prospek/master_status_response.dart';
import 'package:sales/models/response/prospek/show.dart';
import 'package:sales/models/response/prospek_v2/detail_prospek_v2_response.dart';
import 'package:sales/models/response/prospek_v2/list_prospek_v2_response.dart';
import 'package:sales/models/response/rate/show_rate_review_response.dart';
import 'package:sales/models/response/recap_history.dart';
import 'package:sales/models/response/reliver/list_reliver_response.dart';
import 'package:sales/models/response/reliver/show_reliver_response.dart';
import 'package:sales/models/response/store/detail_store_response.dart';
import 'package:sales/models/response/store/list_items.dart';
import 'package:sales/models/response/store/list_store.dart';
import 'package:sales/models/response/update_profile_response.dart';
import 'package:sales/models/response/user/logout_response.dart';
import 'package:sales/models/response/user/user_schedule.dart';
import 'package:sales/models/response/user/users_response.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'api.dart';

class ApiRepository {
  ApiRepository({required this.apiProvider});

  final ApiProvider apiProvider;
  final int timeout = 30;

  Future<LoginRespons?> login(
    String username,
    String password,
    LoginRequest data,
  ) async {
    try {
      final res = await apiProvider
          .login('/api/v2/login', data)
          .timeout(Duration(seconds: timeout));
      if (res.statusCode == 200 || res.statusCode == 401) {
        final body = res.body;
        if (body is Map<String, dynamic>) {
          return LoginRespons.fromJson(body);
        }
        if (body is Map) {
          return LoginRespons.fromJson(Map<String, dynamic>.from(body));
        }
        if (body is String) {
          return LoginResponsFromJson(body);
        }
        throw FormatException('Unexpected response body: ${body.runtimeType}');
      } else {
        if (kDebugMode) {
          print(
            '[HTTP] login failed: status=${res.statusCode} bodyType=${res.body.runtimeType}',
          );
          print('[HTTP] login failed: statusText=${res.statusText}');
          if (res.body != null) print(res.body);
        }

        if (res.statusCode == -1) {
          EasyLoading.showError('Tidak ada koneksi internet');
        } else if (res.status.connectionError) {
          EasyLoading.showError(
            'Gagal terhubung ke server. Coba ganti jaringan / matikan IPv6.',
          );
        } else {
          EasyLoading.showError('Login gagal (${res.statusCode})');
        }
        EasyLoading.dismiss();
      }
    } on TimeoutException catch (_) {
      EasyLoading.showError('Connection Timeout. Please try again later');
      EasyLoading.dismiss();
    } catch (exception, stackTrace) {
      final message = exception.toString();
      if (message.contains('Request dibatalkan')) return null;

      if (kDebugMode) {
        print('[HTTP] login exception: $exception');
        print(stackTrace);
      }
      EasyLoading.showError('Terjadi kesalahan. Silakan coba lagi.');
      EasyLoading.dismiss();
    }
    return null;
  }

  Future<LogoutResponse?> logout(LogoutRequest data) async {
    final res = await apiProvider
        .logout('/api/v2/v1/auth/logout', data)
        .timeout(Duration(seconds: timeout));
    if (res.statusCode == 200) {
      return LogoutResponse.fromJson(res.body);
    }
    return null;
  }

  Future<UsersResponse?> getUsers() async {
    final res = await apiProvider.getUsers('/api/v2/users?page=1&per_page=12');
    if (res.statusCode == 200) {
      return UsersResponse.fromJson(res.body);
    }
    return null;
  }

  Future<UserScheduleResponse?> getUserSchedule() async {
    final res = await apiProvider.getUserSchedule('/api/v2/user/schedule');
    if (res.statusCode == 200) {
      return UserScheduleResponse.fromJson(res.body);
    }
    return null;
  }

  Future<RecapHistoryResponse?> getRecapHistory(IdRequest data) async {
    try {
      final res = await apiProvider
          .getRecapHistory('/api/v2/listAbsen', data)
          .timeout(Duration(seconds: timeout));

      if (res.statusCode == -1) {
        return RecapHistoryResponse(
          error: true,
          message: 'Tidak ada koneksi internet',
          data: const <DataHistory>[],
        );
      }

      final body = res.body;
      if (body == null) {
        return RecapHistoryResponse(
          error: true,
          message: 'Server tidak merespon',
          data: const <DataHistory>[],
        );
      }
      if (body is Map<String, dynamic>) {
        return RecapHistoryResponse.fromJson(body);
      }
      if (body is Map) {
        return RecapHistoryResponse.fromJson(Map<String, dynamic>.from(body));
      }
      if (body is String) {
        return recapHistoryResponseFromJson(body);
      }
    } on TimeoutException catch (_) {
      EasyLoading.showError('Connection Timeout. Please try again later');
      EasyLoading.dismiss();
    } catch (exception) {
      print(exception);
    }
    return null;
  }

  Future<AttendanceValidateResponse?> validateAttendance(
    AttendanceValidateRequest request,
  ) async {
    final link = '/api/v2/beforeAbsen';
    try {
      final res = await apiProvider
          .validateAttendance(link, request)
          .timeout(Duration(seconds: timeout));
      if (res.statusCode == 200 || res.statusCode == 401) {
        return AttendanceValidateResponse.fromJson(res.body);
      }
    } on TimeoutException catch (_) {
      EasyLoading.showError('Connection Timeout. Please try again later');
      EasyLoading.dismiss();
    } catch (exception) {
      print(exception);
    }
    return null;
  }

  Future<AttendanceSubmitResponse?> submitAttendance(
    AttendanceSubmitRequest data,
  ) async {
    try {
      final res = await apiProvider
          .submitAttendance('/api/v2/absen', data)
          .timeout(Duration(seconds: timeout));
      if (res.statusCode == 200 || res.statusCode == 401) {
        return AttendanceSubmitResponse.fromJson(res.body);
      }
    } on TimeoutException catch (_) {
      EasyLoading.showError('Connection Timeout. Please try again later');
      EasyLoading.dismiss();
    } catch (exception) {
      print(exception);
    }
    return null;
  }

  Future<AttendanceSubmitResponse?> submitAttendanceOut(
    AttendanceSubmitRequest data,
  ) async {
    try {
      final res = await apiProvider
          .submitAttendance('/api/v2/absenOut', data)
          .timeout(Duration(seconds: timeout));
      if (res.statusCode == 200 || res.statusCode == 401) {
        return AttendanceSubmitResponse.fromJson(res.body);
      }
    } on TimeoutException catch (_) {
      EasyLoading.showError('Connection Timeout. Please try again later');
      EasyLoading.dismiss();
    } catch (exception) {
      print(exception);
    }
    return null;
  }

  //START PROSPEK
  Future<ProspekResponse?> listProspek(
    GetListRequest data, {
    int page = 1,
    int limit = 10,
  }) async {
    try {
      final res = await apiProvider
          .getProspek(
            '/api/v2/getdata?page=' +
                page.toString() +
                '&limit=' +
                limit.toString(),
            data,
          )
          .timeout(Duration(seconds: timeout));
      if (res.statusCode == 200 || res.statusCode == 401) {
        return ProspekResponse.fromJson(res.body);
      }
    } on TimeoutException catch (_) {
      EasyLoading.showError('Connection Timeout. Please try again later');
      EasyLoading.dismiss();
    } catch (exception) {
      print(exception);
    }
    return null;
  }

  Future<MasterDataProspekResponse?> getMasterData() async {
    try {
      final res = await apiProvider
          .getMasterData('/api/v2/getMasterData')
          .timeout(Duration(seconds: timeout));
      if (res.statusCode == 200 || res.statusCode == 401) {
        return MasterDataProspekResponse.fromJson(res.body);
      }
    } on TimeoutException catch (_) {
      EasyLoading.showError('Connection Timeout. Please try again later');
      EasyLoading.dismiss();
    } catch (exception) {
      print(exception);
    }
    return null;
  }

  Future<MasterStatusProspekResponse?> getMasterStatus() async {
    try {
      final res = await apiProvider
          .getMasterData('/api/v2/getCatTrans')
          .timeout(Duration(seconds: timeout));
      if (res.statusCode == 200 || res.statusCode == 401) {
        return MasterStatusProspekResponse.fromJson(res.body);
      }
    } on TimeoutException catch (_) {
      EasyLoading.showError('Connection Timeout. Please try again later');
      EasyLoading.dismiss();
    } catch (exception) {
      print(exception);
    }
    return null;
  }

  Future<ShowProspekResponse?> showProspek(
    String id,
    GetListRequest data,
  ) async {
    try {
      final res = await apiProvider
          .getShowProspek('/api/v2/getdataDetail?noTrans=' + id, data)
          .timeout(Duration(seconds: timeout));
      if (res.statusCode == 200 || res.statusCode == 401) {
        return ShowProspekResponse.fromJson(res.body);
      }
    } on TimeoutException catch (_) {
      EasyLoading.showError('Connection Timeout. Please try again later');
      EasyLoading.dismiss();
    } catch (exception) {
      print(exception);
    }
    return null;
  }

  Future<MasterIdProspekResponse?> getMasterIdProspek() async {
    try {
      final res = await apiProvider
          .getMasterData('/api/v2/getCatSc')
          .timeout(Duration(seconds: timeout));
      if (res.statusCode == 200 || res.statusCode == 401) {
        return MasterIdProspekResponse.fromJson(res.body);
      }
    } on TimeoutException catch (_) {
      EasyLoading.showError('Connection Timeout. Please try again later');
      EasyLoading.dismiss();
    } catch (exception) {
      print(exception);
    }
    return null;
  }

  Future<ErrorResponse?> submitOvertime(SubmitOvertimeRequest data) async {
    try {
      final res = await apiProvider
          .submitOvertime('/api/v2/saveProspek', data)
          .timeout(Duration(seconds: timeout));
      if (res.statusCode == 200) {
        return ErrorResponse.fromJson(res.body);
      }
    } on TimeoutException catch (_) {
      EasyLoading.showError('Connection Timeout. Please try again later');
      EasyLoading.dismiss();
    } catch (exception) {
      print(exception);
    }
    return null;
  }

  Future<ErrorResponse?> submitOvertimeClient(
    SubmitOvertimeClientRequest data,
  ) async {
    try {
      final res = await apiProvider
          .submitOvertimeClient('/api/v2/v1/overtime', data)
          .timeout(Duration(seconds: timeout));
      if (res.statusCode == 200) {
        return ErrorResponse.fromJson(res.body);
      }
    } on TimeoutException catch (_) {
      EasyLoading.showError('Connection Timeout. Please try again later');
      EasyLoading.dismiss();
    } catch (exception) {
      print(exception);
    }
    return null;
  }

  Future<ErrorResponse?> updateApprovalOvertime(
    String id,
    UpdateApprovalOvertimeRequest data,
  ) async {
    try {
      final res = await apiProvider
          .updateApprovalOvertime('/api/v2/updateProspek', data)
          .timeout(Duration(seconds: timeout));
      if (res.statusCode == 200 || res.statusCode == 401) {
        return ErrorResponse.fromJson(res.body);
      }
    } on TimeoutException catch (_) {
      EasyLoading.showError('Connection Timeout. Please try again later');
      EasyLoading.dismiss();
    } catch (exception) {
      print(exception);
    }
    return null;
  }

  Future<ErrorResponse?> setDoneOvertime(
    String id,
    SetDoneOvertimeRequest data,
  ) async {
    print(data);
    try {
      final res = await apiProvider
          .setDoneOvertime('/api/v2/v1/overtime/set-done/' + id, data)
          .timeout(Duration(seconds: timeout));
      print(res);
      if (res.statusCode == 200 || res.statusCode == 401) {
        return ErrorResponse.fromJson(res.body);
      }
    } on TimeoutException catch (_) {
      EasyLoading.showError('Connection Timeout. Please try again later');
      EasyLoading.dismiss();
    } catch (exception) {
      print(exception);
    }
    return null;
  }
  //END PROSPEK

  Future<TypeCutiResponse?> typeCuti({int page = 1, int limit = 10}) async {
    try {
      final res = await apiProvider
          .getTypeCuti('/api/v2/v1/cuti/type')
          .timeout(Duration(seconds: timeout));
      if (res.statusCode == 200 || res.statusCode == 401) {
        return TypeCutiResponse.fromJson(res.body);
      }
    } on TimeoutException catch (_) {
      EasyLoading.showError('Connection Timeout. Please try again later');
      EasyLoading.dismiss();
    } catch (exception) {
      print(exception);
    }
    return null;
  }

  Future<ShowCutiResponse?> showCuti(String id) async {
    print(id);
    try {
      final res = await apiProvider
          .getShowCuti('/api/v2/v1/cuti/' + id)
          .timeout(Duration(seconds: timeout));
      if (res.statusCode == 200 || res.statusCode == 401) {
        return ShowCutiResponse.fromJson(res.body);
      }
    } on TimeoutException catch (_) {
      EasyLoading.showError('Connection Timeout. Please try again later');
      EasyLoading.dismiss();
    } catch (exception) {
      print(exception);
    }
    return null;
  }

  Future<BenefitDashboardResponse?> listBenefitDashboard(IdRequest data) async {
    try {
      final res = await apiProvider
          .getBenefitDashboard('/api/v2/benefit', data)
          .timeout(Duration(seconds: timeout));
      if (res.statusCode == 200 || res.statusCode == 401) {
        return BenefitDashboardResponse.fromJson(res.body);
      }
    } on TimeoutException catch (_) {
      EasyLoading.showError('Connection Timeout. Please try again later');
      EasyLoading.dismiss();
    } catch (exception) {
      print(exception);
    }
    return null;
  }

  Future<ShowCutiResponse?> submitCuti(SubmitCutiRequest data) async {
    try {
      final res = await apiProvider
          .submitCuti('/api/v2/v1/cuti', data)
          .timeout(Duration(seconds: timeout));
      if (res.statusCode == 200 || res.statusCode == 401) {
        return ShowCutiResponse.fromJson(res.body);
      }
    } on TimeoutException catch (_) {
      EasyLoading.showError('Connection Timeout. Please try again later');
      EasyLoading.dismiss();
    } catch (exception) {
      print(exception);
    }
    return null;
  }

  Future<ErrorResponse?> updateApprovalCuti(
    String id,
    UpdateApprovalCutiRequest data,
  ) async {
    try {
      final res = await apiProvider
          .updateApprovalCuti('/api/v2/v1/cuti/update-status/' + id, data)
          .timeout(Duration(seconds: timeout));
      if (res.statusCode == 200 || res.statusCode == 401) {
        return ErrorResponse.fromJson(res.body);
      }
    } on TimeoutException catch (_) {
      EasyLoading.showError('Connection Timeout. Please try again later');
      EasyLoading.dismiss();
    } catch (exception) {
      print(exception);
    }
    return null;
  }

  Future<ShowCutiResponse?> updateCuti(
    String id,
    SubmitCutiRequest data,
  ) async {
    print(data);
    try {
      final res = await apiProvider
          .updateCuti('/api/v2/v1/cuti/' + id, data)
          .timeout(Duration(seconds: timeout));
      print(res);
      if (res.statusCode == 200 || res.statusCode == 401) {
        return ShowCutiResponse.fromJson(res.body);
      }
    } on TimeoutException catch (_) {
      EasyLoading.showError('Connection Timeout. Please try again later');
      EasyLoading.dismiss();
    } catch (exception) {
      print(exception);
    }
    return null;
  }
  //END BENEFIT

  //START IZIN
  Future<IzinResponse?> listIzin({
    int page = 1,
    int limit = 10,
    required IdRequest data,
  }) async {
    try {
      final res = await apiProvider
          .getIzin('/api/v2/listIjin?page=' + page.toString(), data)
          .timeout(Duration(seconds: timeout));
      if (res.statusCode == 200 || res.statusCode == 401) {
        return IzinResponse.fromJson(res.body);
      }
    } on TimeoutException catch (_) {
      EasyLoading.showError('Connection Timeout. Please try again later');
      EasyLoading.dismiss();
    } catch (exception) {
      print(exception);
    }
    return null;
  }

  Future<TypeIzinResponse?> typeIzin() async {
    try {
      final res = await apiProvider
          .getTypeIzin('/api/v2/masterIjin')
          .timeout(Duration(seconds: timeout));
      if (res.statusCode == 200 || res.statusCode == 401) {
        return TypeIzinResponse.fromJson(res.body);
      }
    } on TimeoutException catch (_) {
      EasyLoading.showError('Connection Timeout. Please try again later');
      EasyLoading.dismiss();
    } catch (exception) {
      print(exception);
    }
    return null;
  }

  Future<ShowIzinResponse?> showIzin(ShowLeaveRequest data) async {
    try {
      final res = await apiProvider
          .getShowIzin('/api/v2/detailIjin', data)
          .timeout(Duration(seconds: timeout));
      if (res.statusCode == 200 || res.statusCode == 401) {
        return ShowIzinResponse.fromJson(res.body);
      }
    } on TimeoutException catch (_) {
      EasyLoading.showError('Connection Timeout. Please try again later');
      EasyLoading.dismiss();
    } catch (exception) {
      print(exception);
    }
    return null;
  }

  Future<ErrorResponse?> submitIzin(SubmitIzinRequest data) async {
    try {
      final res = await apiProvider
          .submitIzin('/api/v2/ijin', data)
          .timeout(Duration(seconds: timeout));
      if (res.statusCode == 200 || res.statusCode == 401) {
        return ErrorResponse.fromJson(res.body);
      }
    } on TimeoutException catch (_) {
      EasyLoading.showError('Connection Timeout. Please try again later');
      EasyLoading.dismiss();
    } catch (exception) {
      print(exception);
    }
    return null;
  }

  Future<ErrorResponse?> updateApprovalIzin(
    String id,
    UpdateApprovalIzinRequest data,
  ) async {
    try {
      final res = await apiProvider
          .updateApprovalIzin('/api/v2/v1/izin/update-status/' + id, data)
          .timeout(Duration(seconds: timeout));
      if (res.statusCode == 200 || res.statusCode == 401) {
        return ErrorResponse.fromJson(res.body);
      }
    } on TimeoutException catch (_) {
      EasyLoading.showError('Connection Timeout. Please try again later');
      EasyLoading.dismiss();
    } catch (exception) {
      print(exception);
    }
    return null;
  }

  Future<ErrorResponse?> updateIzin(String id, SubmitIzinRequest data) async {
    print(data);
    try {
      final res = await apiProvider
          .updateIzin('/api/v2/v1/izin/set-done/' + id, data)
          .timeout(Duration(seconds: timeout));
      print(res);
      if (res.statusCode == 200 || res.statusCode == 401) {
        return ErrorResponse.fromJson(res.body);
      }
    } on TimeoutException catch (_) {
      EasyLoading.showError('Connection Timeout. Please try again later');
      EasyLoading.dismiss();
    } catch (exception) {
      print(exception);
    }
    return null;
  }

  //RELIVER
  Future<EventResponse?> listEvent({int page = 1, int limit = 10}) async {
    try {
      final res = await apiProvider
          .getReliver('/api/v2/listEvent')
          .timeout(Duration(seconds: timeout));
      if (res.statusCode == 200 || res.statusCode == 401) {
        return EventResponse.fromJson(res.body);
      }
    } on TimeoutException catch (_) {
      EasyLoading.showError('Connection Timeout. Please try again later');
      EasyLoading.dismiss();
    } catch (exception) {
      print(exception);
    }
    return null;
  }

  Future<ShowReliverResponse?> showReliver(ShowEventRequest data) async {
    try {
      final res = await apiProvider
          .getShowReliver('/api/v2/detailEvent', data)
          .timeout(Duration(seconds: timeout));
      if (res.statusCode == 200 || res.statusCode == 401) {
        return ShowReliverResponse.fromJson(res.body);
      }
    } on TimeoutException catch (_) {
      EasyLoading.showError('Connection Timeout. Please try again later');
      EasyLoading.dismiss();
    } catch (exception) {
      print(exception);
    }
    return null;
  }

  Future<ErrorResponse?> submitReliver(CreateReliverRequest data) async {
    try {
      print(data);
      final res = await apiProvider
          .submitReliver('/api/v2/v1/reliver', data)
          .timeout(Duration(seconds: timeout));
      if (res.statusCode == 200 || res.statusCode == 401) {
        return ErrorResponse.fromJson(res.body);
      }
    } on TimeoutException catch (_) {
      EasyLoading.showError('Connection Timeout. Please try again later');
      EasyLoading.dismiss();
    } catch (exception) {
      print(exception);
    }
    return null;
  }

  Future<ErrorResponse?> updateApprovalReliver(
    String id,
    ApproveReliverRequest data,
  ) async {
    try {
      final res = await apiProvider
          .updateApprovalReliver('/api/v2/v1/reliver/approve/' + id, data)
          .timeout(Duration(seconds: timeout));
      if (res.statusCode == 200 || res.statusCode == 401) {
        return ErrorResponse.fromJson(res.body);
      }
    } on TimeoutException catch (_) {
      EasyLoading.showError('Connection Timeout. Please try again later');
      EasyLoading.dismiss();
    } catch (exception) {
      print(exception);
    }
    return null;
  }
  //END RELIVER

  Future<ErrorResponse?> deleteTaskList(String idTask, String idType) async {
    try {
      final res = await apiProvider
          .deleteTaskList('/api/v2/v1/task/' + idTask + '/' + idType)
          .timeout(Duration(seconds: timeout));
      if (res.statusCode == 200 || res.statusCode == 401) {
        return ErrorResponse.fromJson(res.body);
      }
    } on TimeoutException catch (_) {
      EasyLoading.showError('Connection Timeout. Please try again later');
      EasyLoading.dismiss();
    } catch (exception) {
      print(exception);
    }
    return null;
  }

  Future<BranchListResponse?> branchList({
    int page = 1,
    int limit = 100,
  }) async {
    try {
      final res = await apiProvider
          .getBranchList('/api/v2/v1/branch?limit=' + limit.toString())
          .timeout(Duration(seconds: timeout));
      if (res.statusCode == 200) {
        return BranchListResponse.fromJson(res.body);
      }
    } on TimeoutException catch (_) {
      EasyLoading.showError('Connection Timeout. Please try again later');
      EasyLoading.dismiss();
    } catch (exception) {
      print(exception);
    }
    return null;
  }

  Future<NameTadListResponse?> branchNameTad({branchId = 0}) async {
    print(branchId);
    try {
      final res = await apiProvider
          .getBranchList(
            '/api/v2/v1/branch/tad-users?branch_id=' + branchId.toString(),
          )
          .timeout(Duration(seconds: timeout));
      print(res);
      if (res.statusCode == 200) {
        return NameTadListResponse.fromJson(res.body);
      }
    } on TimeoutException catch (_) {
      EasyLoading.showError('Connection Timeout. Please try again later');
      EasyLoading.dismiss();
    } catch (exception) {
      print(exception);
    }
    return null;
  }

  Future<ErrorResponse?> updateFcmProfile(UpdateFcmProfileRequest data) async {
    try {
      final res = await apiProvider
          .updateFcmProfile('/api/v2/v1/auth/update', data)
          .timeout(Duration(seconds: timeout));
      print(res);
      if (res.statusCode == 200 || res.statusCode == 401) {
        return ErrorResponse.fromJson(res.body);
      }
    } on TimeoutException catch (_) {
      EasyLoading.showError('Connection Timeout. Please try again later');
      EasyLoading.dismiss();
    } catch (exception) {
      print(exception);
    }
    return null;
  }

  Future<UpdateProfileResponse?> updatePhotoProfile(
    UpdatePhotoProfileRequest data,
  ) async {
    try {
      final res = await apiProvider
          .updatePhotoProfile('/api/v2/v1/auth/update', data)
          .timeout(Duration(seconds: timeout));
      print(res);
      if (res.statusCode == 200 || res.statusCode == 401) {
        return UpdateProfileResponse.fromJson(res.body);
      }
    } on TimeoutException catch (_) {
      EasyLoading.showError('Connection Timeout. Please try again later');
      EasyLoading.dismiss();
    } catch (exception) {
      print(exception);
    }
    return null;
  }

  Future<ShowReviewRateResponse?> getRate() async {
    try {
      final res = await apiProvider
          .getRate('/api/v2/v1/rate')
          .timeout(Duration(seconds: timeout));
      print(res);
      if (res.statusCode == 200) {
        return ShowReviewRateResponse.fromJson(res.body);
      }
    } on TimeoutException catch (_) {
      EasyLoading.showError('Connection Timeout. Please try again later');
      EasyLoading.dismiss();
    } catch (exception) {
      print(exception);
    }
    return null;
  }

  Future<ShowReviewRateResponse?> submitRate(SubmitRate data) async {
    try {
      final res = await apiProvider
          .submitRate('/api/v2/v1/rate', data)
          .timeout(Duration(seconds: timeout));
      print(res);
      if (res.statusCode == 200) {
        return ShowReviewRateResponse.fromJson(res.body);
      }
    } on TimeoutException catch (_) {
      EasyLoading.showError('Connection Timeout. Please try again later');
      EasyLoading.dismiss();
    } catch (exception) {
      print(exception);
    }
    return null;
  }

  Future<ErrorResponse?> submitInput(SubmitInputRequest data) async {
    try {
      final res = await apiProvider
          .submitInput('/api/v2/saveCall', data)
          .timeout(Duration(seconds: timeout));
      if (res.statusCode == 200 || res.statusCode == 401) {
        return ErrorResponse.fromJson(res.body);
      }
    } on TimeoutException catch (_) {
      EasyLoading.showError('Connection Timeout. Please try again later');
      EasyLoading.dismiss();
    } catch (exception) {
      print(exception);
    }
    return null;
  }

  Future<ErrorResponse?> submitKuisioner(SubmitKuisionerRequest data) async {
    try {
      final res = await apiProvider
          .submitKuisioner('/api/v2/simpanQuisionerKedua', data)
          .timeout(Duration(seconds: timeout));
      if (res.statusCode == 200 || res.statusCode == 401) {
        return ErrorResponse.fromJson(res.body);
      }
    } on TimeoutException catch (_) {
      EasyLoading.showError('Connection Timeout. Please try again later');
      EasyLoading.dismiss();
    } catch (exception) {
      print(exception);
    }
    return null;
  }

  Future<InputDataKuisionerRespons?> submitDataKuisioner(
    KuisionerInputDataRequest data,
  ) async {
    try {
      final res = await apiProvider
          .submitInputDataKuisioner('/api/v2/simpanQuisionerAwal', data)
          .timeout(Duration(seconds: timeout));
      if (res.statusCode == 200 || res.statusCode == 401) {
        return InputDataKuisionerRespons.fromJson(res.body);
      }
    } on TimeoutException catch (_) {
      EasyLoading.showError('Connection Timeout. Please try again later');
      EasyLoading.dismiss();
    } catch (exception) {
      print(exception);
    }
    return null;
  }

  Future<AttendanceValidateResponse?> validateAttendanceStore(
    AttendanceValidateRequest request,
  ) async {
    final link = '/api/v2/beforeAbsenKampas';
    try {
      final res = await apiProvider
          .validateAttendance(link, request)
          .timeout(Duration(seconds: timeout));
      if (res.statusCode == 200 || res.statusCode == 401) {
        return AttendanceValidateResponse.fromJson(res.body);
      }
    } on TimeoutException catch (_) {
      EasyLoading.showError('Connection Timeout. Please try again later');
      EasyLoading.dismiss();
    } catch (exception) {
      print(exception);
    }
    return null;
  }

  Future<AttendanceSubmitResponse?> submitAttendanceStore(
    AttendanceSubmitRequestWrapper data,
  ) async {
    try {
      final res = await apiProvider
          .submitKunjungan('/api/v2/chekInkampas', data)
          .timeout(Duration(seconds: timeout));
      if (res.statusCode == 200 || res.statusCode == 401) {
        return AttendanceSubmitResponse.fromJson(res.body);
      }
    } on TimeoutException catch (_) {
      EasyLoading.showError('Connection Timeout. Please try again later');
      EasyLoading.dismiss();
    } catch (exception) {
      print(exception);
    }
    return null;
  }

  Future<AttendanceSubmitResponse?> submitNonScheduleVisited(
    NonScheduleSubmitRequest data,
  ) async {
    try {
      final res = await apiProvider
          .submitNonKunjungan('/api/v2/simpanKunjunganNon', data)
          .timeout(Duration(seconds: timeout));
      if (res.statusCode == 200 || res.statusCode == 401) {
        return AttendanceSubmitResponse.fromJson(res.body);
      }
    } on TimeoutException catch (_) {
      EasyLoading.showError('Connection Timeout. Please try again later');
      EasyLoading.dismiss();
    } catch (exception) {
      print(exception);
    }
    return null;
  }

  Future<AttendanceSubmitResponse?> submitAttendanceOutStore(
    AttendanceSubmitRequest data,
  ) async {
    try {
      final res = await apiProvider
          .submitAttendance('/api/v2/chekOutkampas', data)
          .timeout(Duration(seconds: timeout));
      if (res.statusCode == 200 || res.statusCode == 401) {
        return AttendanceSubmitResponse.fromJson(res.body);
      }
    } on TimeoutException catch (_) {
      EasyLoading.showError('Connection Timeout. Please try again later');
      EasyLoading.dismiss();
    } catch (exception) {
      print(exception);
    }
    return null;
  }

  Future<KanvasResponse?> listStore({
    int page = 1,
    int limit = 10,
    required UserIdRequest data,
  }) async {
    try {
      final res = await apiProvider
          .getStore('/api/v2/ListKampas?user_id=' + data.id)
          .timeout(Duration(seconds: timeout));
      if (res.statusCode == 200 || res.statusCode == 401) {
        return KanvasResponse.fromJson(res.body);
      }
    } on TimeoutException catch (_) {
      EasyLoading.showError('Connection Timeout. Please try again later');
      EasyLoading.dismiss();
    } catch (exception) {
      print(exception);
    }
    return null;
  }

  Future<ErrorResponse?> decreaseQtyItems(QtyUpdateRequest data) async {
    try {
      final res = await apiProvider
          .submitQtyInput('/api/v2/qtyKurang', data)
          .timeout(Duration(seconds: timeout));
      if (res.statusCode == 200 || res.statusCode == 401) {
        return ErrorResponse.fromJson(res.body);
      }
    } on TimeoutException catch (_) {
      EasyLoading.showError('Connection Timeout. Please try again later');
      EasyLoading.dismiss();
    } catch (exception) {
      print(exception);
    }
    return null;
  }

  Future<ListItemsResponse?> listItems({
    int page = 1,
    int limit = 10,
    required UserIdRequest data,
  }) async {
    try {
      final res = await apiProvider
          .getStore('/api/v2/ListBarangKanvas?user_id=' + data.id)
          .timeout(Duration(seconds: timeout));
      if (res.statusCode == 200 || res.statusCode == 401) {
        return ListItemsResponse.fromJson(res.body);
      }
    } on TimeoutException catch (_) {
      EasyLoading.showError('Connection Timeout. Please try again later');
      EasyLoading.dismiss();
    } catch (exception) {
      print(exception);
    }
    return null;
  }

  Future<ListKuisionerRespons?> listKuisioner({
    required ListKuisionerRequest data,
  }) async {
    try {
      final res = await apiProvider
          .getKuisioner('/api/v2/listQuisioner', data)
          .timeout(Duration(seconds: timeout));
      if (res.statusCode == 200 || res.statusCode == 401) {
        return ListKuisionerRespons.fromJson(res.body);
      }
    } on TimeoutException catch (_) {
      EasyLoading.showError('Connection Timeout. Please try again later');
      EasyLoading.dismiss();
    } catch (exception) {
      print(exception);
    }
    return null;
  }

  //START LEMBUR
  Future<LemburResponse?> listLembur({required UserIdRequest data}) async {
    try {
      final res = await apiProvider
          .getLembur('/api/v2/list_lembur', data)
          .timeout(Duration(seconds: timeout));
      if (res.statusCode == 200 || res.statusCode == 401) {
        return LemburResponse.fromJson(res.body);
      }
    } on TimeoutException catch (_) {
      EasyLoading.showError('Connection Timeout. Please try again later');
      EasyLoading.dismiss();
    } catch (exception) {
      print(exception);
    }
    return null;
  }

  Future<ShowLemburResponse?> showLembur(ShowLemburRequest data) async {
    try {
      final res = await apiProvider
          .getShowLembur('/api/v2/detail_lembur', data)
          .timeout(Duration(seconds: timeout));
      if (res.statusCode == 200 || res.statusCode == 401) {
        return ShowLemburResponse.fromJson(res.body);
      }
    } on TimeoutException catch (_) {
      EasyLoading.showError('Connection Timeout. Please try again later');
      EasyLoading.dismiss();
    } catch (exception) {
      print(exception);
    }
    return null;
  }

  Future<ErrorResponse?> submitLembur(SubmitLemburRequest data) async {
    try {
      final res = await apiProvider
          .submitLembur('/api/v2/simpan_lembur', data)
          .timeout(Duration(seconds: timeout));
      if (res.statusCode == 200 || res.statusCode == 401) {
        return ErrorResponse.fromJson(res.body);
      }
    } on TimeoutException catch (_) {
      EasyLoading.showError('Connection Timeout. Please try again later');
      EasyLoading.dismiss();
    } catch (exception) {
      print(exception);
    }
    return null;
  }

  Future<ErrorResponse?> updateApprovalLembur(
    UpdateApprovalLemburRequest data,
  ) async {
    try {
      final res = await apiProvider
          .updateApprovalLembur('/api/v2/approve_lembur', data)
          .timeout(Duration(seconds: timeout));
      if (res.statusCode == 200 || res.statusCode == 401) {
        return ErrorResponse.fromJson(res.body);
      }
    } on TimeoutException catch (_) {
      EasyLoading.showError('Connection Timeout. Please try again later');
      EasyLoading.dismiss();
    } catch (exception) {
      print(exception);
    }
    return null;
  }

  Future<ErrorResponse?> updateLembur(
    String id,
    SubmitLemburRequest data,
  ) async {
    print(data);
    try {
      final res = await apiProvider
          .updateLembur('/api/v2/v1/izin/set-done/' + id, data)
          .timeout(Duration(seconds: timeout));
      print(res);
      if (res.statusCode == 200 || res.statusCode == 401) {
        return ErrorResponse.fromJson(res.body);
      }
    } on TimeoutException catch (_) {
      EasyLoading.showError('Connection Timeout. Please try again later');
      EasyLoading.dismiss();
    } catch (exception) {
      print(exception);
    }
    return null;
  }

  Future<ErrorResponse?> submitLead(SubmitLeadRequest data) async {
    try {
      final res = await apiProvider
          .submitLead('/api/v2/simpan_leads', data)
          .timeout(Duration(seconds: timeout));
      if (res.statusCode == 200 || res.statusCode == 401) {
        return ErrorResponse.fromJson(res.body);
      }
    } on TimeoutException catch (_) {
      EasyLoading.showError('Connection Timeout. Please try again later');
      EasyLoading.dismiss();
    } catch (exception) {
      print(exception);
    }
    return null;
  }

  Future<LeadResponse?> listLeads({required UserIdRequest data}) async {
    try {
      final res = await apiProvider
          .getLeads('/api/v2/get_leads', data)
          .timeout(Duration(seconds: timeout));
      if (res.statusCode == 200 || res.statusCode == 401) {
        return LeadResponse.fromJson(res.body);
      }
    } on TimeoutException catch (_) {
      EasyLoading.showError('Connection Timeout. Please try again later');
      EasyLoading.dismiss();
    } catch (exception) {
      print(exception);
    }
    return null;
  }

  Future<MasterData2Response?> getMasterData2(
    String filter, {
    String userId = '0',
  }) async {
    try {
      String url = '';
      if (userId != '0') {
        url = '/api/v2/getMaster?flag=' + filter + '&user_id=' + userId;
      } else {
        url = '/api/v2/getMaster?flag=' + filter;
      }
      final res = await apiProvider
          .getMasterData(url)
          .timeout(Duration(seconds: timeout));
      if (res.statusCode == 200 || res.statusCode == 401) {
        return MasterData2Response.fromJson(res.body);
      }
    } on TimeoutException catch (_) {
      EasyLoading.showError('Connection Timeout. Please try again later');
      EasyLoading.dismiss();
    } catch (exception) {
      print(exception);
    }
    return null;
  }

  Future<DetailStoreResponse?> showDetailKunjungan(
    ShowDetailKunjunganRequest data,
  ) async {
    try {
      final res = await apiProvider
          .getShowKunjungan('/api/v2/DetailListKampas', data)
          .timeout(Duration(seconds: timeout));
      if (res.statusCode == 200 || res.statusCode == 401) {
        return DetailStoreResponse.fromJson(res.body);
      }
    } on TimeoutException catch (_) {
      EasyLoading.showError('Connection Timeout. Please try again later');
      EasyLoading.dismiss();
    } catch (exception) {
      print(exception);
    }
    return null;
  }

  //START LEMBUR
  Future<CutiSalesResponse?> listCuti({required UserIdRequest data}) async {
    try {
      final res = await apiProvider
          .getLembur('/api/v2/list_cuti', data)
          .timeout(Duration(seconds: timeout));
      if (res.statusCode == 200 || res.statusCode == 401) {
        return CutiSalesResponse.fromJson(res.body);
      }
    } on TimeoutException catch (_) {
      EasyLoading.showError('Connection Timeout. Please try again later');
      EasyLoading.dismiss();
    } catch (exception) {
      print(exception);
    }
    return null;
  }

  Future<ShowCutiSalesResponse?> showCutiSales(
    ShowCutiSalesRequest data,
  ) async {
    try {
      final res = await apiProvider
          .getShowCutiSales('/api/v2/detail_cuti', data)
          .timeout(Duration(seconds: timeout));
      if (res.statusCode == 200 || res.statusCode == 401) {
        return ShowCutiSalesResponse.fromJson(res.body);
      }
    } on TimeoutException catch (_) {
      EasyLoading.showError('Connection Timeout. Please try again later');
      EasyLoading.dismiss();
    } catch (exception) {
      print(exception);
    }
    return null;
  }

  Future<ErrorResponse?> submitCutiSales(SubmitCutiSalesRequest data) async {
    try {
      final res = await apiProvider
          .submitCutiSales('/api/v2/simpan_cuti', data)
          .timeout(Duration(seconds: timeout));
      if (res.statusCode == 200 || res.statusCode == 401) {
        return ErrorResponse.fromJson(res.body);
      }
    } on TimeoutException catch (_) {
      EasyLoading.showError('Connection Timeout. Please try again later');
      EasyLoading.dismiss();
    } catch (exception) {
      print(exception);
    }
    return null;
  }

  Future<ErrorResponse?> updateApprovalCutiSales(
    UpdateApprovalCutiSalesRequest data,
  ) async {
    try {
      final res = await apiProvider
          .updateApprovalCutiSales('/api/v2/approve_cuti', data)
          .timeout(Duration(seconds: timeout));
      if (res.statusCode == 200 || res.statusCode == 401) {
        return ErrorResponse.fromJson(res.body);
      }
    } on TimeoutException catch (_) {
      EasyLoading.showError('Connection Timeout. Please try again later');
      EasyLoading.dismiss();
    } catch (exception) {
      print(exception);
    }
    return null;
  }

  Future<ErrorResponse?> updateCutiSales(
    String id,
    SubmitCutiSalesRequest data,
  ) async {
    print(data);
    try {
      final res = await apiProvider
          .updateCutiSales('/api/v2/v1/izin/set-done/' + id, data)
          .timeout(Duration(seconds: timeout));
      print(res);
      if (res.statusCode == 200 || res.statusCode == 401) {
        return ErrorResponse.fromJson(res.body);
      }
    } on TimeoutException catch (_) {
      EasyLoading.showError('Connection Timeout. Please try again later');
      EasyLoading.dismiss();
    } catch (exception) {
      print(exception);
    }
    return null;
  }

  //START SHIFT SWAP
  Future<ShiftSwapListResponse?> listShiftSwap({
    required UserIdRequest data,
  }) async {
    try {
      final res = await apiProvider
          .getShiftSwap('/api/v2/list_tukar_shift', data)
          .timeout(Duration(seconds: timeout));
      if (res.statusCode == 200 || res.statusCode == 401) {
        return ShiftSwapListResponse.fromJson(res.body);
      }
    } on TimeoutException catch (_) {
      EasyLoading.showError('Connection Timeout. Please try again later');
      EasyLoading.dismiss();
    } catch (exception) {
      print(exception);
    }
    return null;
  }

  Future<ShowShiftSwapResponse?> showShiftSwap(
    ShowShiftSwapRequest data,
  ) async {
    try {
      final res = await apiProvider
          .getShowShiftSwap('/api/v2/detail_tukar_shift', data)
          .timeout(Duration(seconds: timeout));
      if (res.statusCode == 200 || res.statusCode == 401) {
        return ShowShiftSwapResponse.fromJson(res.body);
      }
    } on TimeoutException catch (_) {
      EasyLoading.showError('Connection Timeout. Please try again later');
      EasyLoading.dismiss();
    } catch (exception) {
      print(exception);
    }
    return null;
  }

  Future<ErrorResponse?> submitShiftSwap(SubmitShiftSwapRequest data) async {
    try {
      final res = await apiProvider
          .submitShiftSwap('/api/v2/simpan_tukar_shift', data)
          .timeout(Duration(seconds: timeout));
      if (res.statusCode == 200 || res.statusCode == 401) {
        return ErrorResponse.fromJson(res.body);
      }
    } on TimeoutException catch (_) {
      EasyLoading.showError('Connection Timeout. Please try again later');
      EasyLoading.dismiss();
    } catch (exception) {
      print(exception);
    }
    return null;
  }

  Future<ErrorResponse?> updateApprovalShiftSwap(
    UpdateApprovalShiftSwapRequest data,
  ) async {
    try {
      final res = await apiProvider
          .updateApprovalShiftSwap('/api/v2/approve_tukar_shift', data)
          .timeout(Duration(seconds: timeout));
      if (res.statusCode == 200 || res.statusCode == 401) {
        return ErrorResponse.fromJson(res.body);
      }
    } on TimeoutException catch (_) {
      EasyLoading.showError('Connection Timeout. Please try again later');
      EasyLoading.dismiss();
    } catch (exception) {
      print(exception);
    }
    return null;
  }
  //END SHIFT SWAP

  //START CLAIM
  Future<ClaimListResponse?> listClaim({required UserIdRequest data}) async {
    try {
      final res = await apiProvider
          .getClaim('/api/v2/list_claim', data)
          .timeout(Duration(seconds: timeout));
      if (res.statusCode == 200 || res.statusCode == 401) {
        return ClaimListResponse.fromJson(res.body);
      }
    } on TimeoutException catch (_) {
      EasyLoading.showError('Connection Timeout. Please try again later');
      EasyLoading.dismiss();
    } catch (exception) {
      print(exception);
    }
    return null;
  }

  Future<ShowClaimResponse?> showClaim(ShowClaimRequest data) async {
    try {
      final res = await apiProvider
          .getShowClaim('/api/v2/detail_claim', data)
          .timeout(Duration(seconds: timeout));
      if (res.statusCode == 200 || res.statusCode == 401) {
        return ShowClaimResponse.fromJson(res.body);
      }
    } on TimeoutException catch (_) {
      EasyLoading.showError('Connection Timeout. Please try again later');
      EasyLoading.dismiss();
    } catch (exception) {
      print(exception);
    }
    return null;
  }

  Future<ErrorResponse?> submitClaim(SubmitClaimRequest data) async {
    try {
      final res = await apiProvider
          .submitClaim('/api/v2/simpan_claim', data)
          .timeout(Duration(seconds: timeout));
      if (res.statusCode == 200 || res.statusCode == 401) {
        return ErrorResponse.fromJson(res.body);
      }
    } on TimeoutException catch (_) {
      EasyLoading.showError('Connection Timeout. Please try again later');
      EasyLoading.dismiss();
    } catch (exception) {
      print(exception);
    }
    return null;
  }

  Future<ErrorResponse?> updateApprovalClaim(
    UpdateApprovalClaimRequest data,
  ) async {
    try {
      final res = await apiProvider
          .updateApprovalClaim('/api/v2/approve_claim', data)
          .timeout(Duration(seconds: timeout));
      if (res.statusCode == 200 || res.statusCode == 401) {
        return ErrorResponse.fromJson(res.body);
      }
    } on TimeoutException catch (_) {
      EasyLoading.showError('Connection Timeout. Please try again later');
      EasyLoading.dismiss();
    } catch (exception) {
      print(exception);
    }
    return null;
  }
  //END CLAIM

  //START PAYSLIP
  Future<PayslipDownloadResult?> downloadPayslipExcel(
    DownloadPayslipRequest data,
  ) async {
    try {
      final res = await apiProvider
          .downloadPayslipExcel('/api/v2/payslip/excel', data)
          .timeout(Duration(seconds: timeout));
      if (res.statusCode != 200 && res.statusCode != 401) return null;

      final contentType = _headerValue(res.headers, 'content-type') ?? '';
      if (contentType.toLowerCase().contains('application/json')) {
        try {
          final message = ErrorResponse.fromJson(res.body);
          if (message.error == true) {
            EasyLoading.showError(message.message ?? 'Gagal download payslip');
          }
        } catch (_) {
          EasyLoading.showError('Gagal download payslip');
        }
        return null;
      }

      final bytes = await _collectBodyBytes(res.bodyBytes);
      if (bytes == null || bytes.isEmpty) {
        EasyLoading.showError('File kosong / tidak ditemukan');
        return null;
      }

      final filename = _filenameFromContentDisposition(
        _headerValue(res.headers, 'content-disposition'),
      );
      return PayslipDownloadResult(
        bytes: bytes,
        filename: filename,
        mimeType: contentType.isEmpty ? null : contentType,
      );
    } on TimeoutException catch (_) {
      EasyLoading.showError('Connection Timeout. Please try again later');
      EasyLoading.dismiss();
    } catch (exception) {
      print(exception);
    }
    return null;
  }

  Future<PayslipDownloadResult?> downloadPayslipPdf(
    DownloadPayslipRequest data,
  ) async {
    try {
      final listRes = await apiProvider
          .downloadPayslipPdf('/api/v2/listPaySlip', data)
          .timeout(Duration(seconds: timeout));
      if (listRes.statusCode != 200 && listRes.statusCode != 401) return null;

      PayslipListResponse? parsed;
      try {
        final body = listRes.body;
        if (body is Map<String, dynamic>) {
          parsed = PayslipListResponse.fromJson(body);
        } else if (body is Map) {
          parsed =
              PayslipListResponse.fromJson(Map<String, dynamic>.from(body));
        } else if (body is String) {
          parsed = payslipListResponseFromJson(body);
        }
      } catch (_) {
        parsed = null;
      }

      String? path;
      for (final item in parsed?.data ?? const <PayslipListItem>[]) {
        final candidate = (item.path ?? '').trim();
        if (candidate.isNotEmpty) {
          path = candidate;
          break;
        }
      }
      if (path == null || path.isEmpty) {
        EasyLoading.showError(parsed?.message ?? 'Payslip tidak ditemukan');
        return null;
      }

      final fileRes = await apiProvider
          .downloadFileFromUrl(path)
          .timeout(Duration(seconds: timeout));
      if (fileRes.statusCode != 200 && fileRes.statusCode != 401) return null;

      final contentType = _headerValue(fileRes.headers, 'content-type') ?? '';
      if (contentType.toLowerCase().contains('application/json')) {
        try {
          final message = ErrorResponse.fromJson(fileRes.body);
          if (message.error == true) {
            EasyLoading.showError(message.message ?? 'Gagal download payslip');
          }
        } catch (_) {
          EasyLoading.showError('Gagal download payslip');
        }
        return null;
      }

      final bytes = await _collectBodyBytes(fileRes.bodyBytes);
      if (bytes == null || bytes.isEmpty) {
        EasyLoading.showError('File kosong / tidak ditemukan');
        return null;
      }

      final filename = _filenameFromContentDisposition(
              _headerValue(fileRes.headers, 'content-disposition')) ??
          Uri.tryParse(path)?.pathSegments.last;
      return PayslipDownloadResult(
        bytes: bytes,
        filename: filename,
        mimeType: contentType.isEmpty ? 'application/pdf' : contentType,
      );
    } on TimeoutException catch (_) {
      EasyLoading.showError('Connection Timeout. Please try again later');
      EasyLoading.dismiss();
    } catch (exception) {
      print(exception);
    }
    return null;
  }
  //END PAYSLIP

  Future<ErrorResponse?> sumbmitDialogMood(SubmitDialogMoodRequest data) async {
    try {
      final res = await apiProvider
          .submitDialogMood('/api/v2/simpan_emo', data)
          .timeout(Duration(seconds: timeout));
      if (res.statusCode == 200 || res.statusCode == 401) {
        return ErrorResponse.fromJson(res.body);
      }
    } on TimeoutException catch (_) {
      EasyLoading.showError('Connection Timeout. Please try again later');
      EasyLoading.dismiss();
    } catch (exception) {
      print(exception);
    }
    return null;
  }

  String? _headerValue(Map<String, String>? headers, String name) {
    if (headers == null) return null;
    final lowerName = name.toLowerCase();
    for (final entry in headers.entries) {
      if (entry.key.toLowerCase() == lowerName) return entry.value;
    }
    return null;
  }

  String? _filenameFromContentDisposition(String? contentDisposition) {
    if (contentDisposition == null) return null;
    final value = contentDisposition;
    final match = RegExp(
          r"filename\\*=UTF-8''([^;]+)",
          caseSensitive: false,
        ).firstMatch(value) ??
        RegExp(
          r'filename="?([^";]+)"?',
          caseSensitive: false,
        ).firstMatch(value);
    if (match == null) return null;
    final raw = match.group(1);
    if (raw == null || raw.trim().isEmpty) return null;
    return Uri.decodeFull(raw.trim());
  }

  Future<Uint8List?> _collectBodyBytes(dynamic bodyBytes) async {
    if (bodyBytes == null) return null;
    if (bodyBytes is Uint8List) return bodyBytes;
    if (bodyBytes is List<int>) return Uint8List.fromList(bodyBytes);
    if (bodyBytes is Stream<List<int>>) {
      final builder = BytesBuilder(copy: false);
      await for (final chunk in bodyBytes) {
        builder.add(chunk);
      }
      return builder.takeBytes();
    }
    return null;
  }

  Future<DashboardKunjunganResponse?> getDashboardKunjungan(
    DashboardRequest data,
  ) async {
    try {
      final res = await apiProvider
          .getDashboardKunjungan('/api/v2/jumlah_kunjungan', data)
          .timeout(Duration(seconds: timeout));
      if (res.statusCode == 200 || res.statusCode == 401) {
        return DashboardKunjunganResponse.fromJson(res.body);
      }
    } on TimeoutException catch (_) {
      EasyLoading.showError('Connection Timeout. Please try again later');
      EasyLoading.dismiss();
    } catch (exception) {
      print(exception);
    }
    return null;
  }

  Future<ShowProspekV2Response?> showProspekV2(
    ShowProspectV2Request data,
  ) async {
    try {
      final res = await apiProvider
          .getShowProspekV2('/api/v2/detail_prospek', data)
          .timeout(Duration(seconds: timeout));
      if (res.statusCode == 200 || res.statusCode == 401) {
        return ShowProspekV2Response.fromJson(res.body);
      }
    } on TimeoutException catch (_) {
      EasyLoading.showError('Connection Timeout. Please try again later');
      EasyLoading.dismiss();
    } catch (exception) {
      print(exception);
    }
    return null;
  }

  Future<ErrorResponse?> submitProspectV2(SubmitProspekV2Request data) async {
    try {
      final res = await apiProvider
          .submitProspectV2('/api/v2/simpan_prospek', data)
          .timeout(Duration(seconds: timeout));
      if (res.statusCode == 200) {
        return ErrorResponse.fromJson(res.body);
      }
    } on TimeoutException catch (_) {
      EasyLoading.showError('Connection Timeout. Please try again later');
      EasyLoading.dismiss();
    } catch (exception) {
      print(exception);
    }
    return null;
  }

  Future<ProspekV2Response?> listProspekV2(UserIdRequest data) async {
    try {
      final res = await apiProvider
          .getProspekV2('/api/v2/list_prospek', data)
          .timeout(Duration(seconds: timeout));
      if (res.statusCode == 200 || res.statusCode == 401) {
        return ProspekV2Response.fromJson(res.body);
      }
    } on TimeoutException catch (_) {
      EasyLoading.showError('Connection Timeout. Please try again later');
      EasyLoading.dismiss();
    } catch (exception) {
      print(exception);
    }
    return null;
  }

  Future<ErrorResponse?> submitAgent(SubmitAgentRequest data) async {
    try {
      final res = await apiProvider
          .submitAgent('/api/v2/simpan_leads', data)
          .timeout(Duration(seconds: timeout));
      if (res.statusCode == 200 || res.statusCode == 401) {
        return ErrorResponse.fromJson(res.body);
      }
    } on TimeoutException catch (_) {
      EasyLoading.showError('Connection Timeout. Please try again later');
      EasyLoading.dismiss();
    } catch (exception) {
      print(exception);
    }
    return null;
  }

  Future<AgentResponse?> listAgent({required UserIdRequest data}) async {
    try {
      final res = await apiProvider
          .getAgent('/api/v2/get_leads', data)
          .timeout(Duration(seconds: timeout));
      if (res.statusCode == 200 || res.statusCode == 401) {
        return AgentResponse.fromJson(res.body);
      }
    } on TimeoutException catch (_) {
      EasyLoading.showError('Connection Timeout. Please try again later');
      EasyLoading.dismiss();
    } catch (exception) {
      print(exception);
    }
    return null;
  }

  Future<ShowProspekV2Response?> submitStatusLead(
    SubmitStatusLeadRequest data,
  ) async {
    try {
      final res = await apiProvider
          .submitStatusLead('/api/v2/update_leads', data)
          .timeout(Duration(seconds: timeout));
      if (res.statusCode == 200 || res.statusCode == 401) {
        return ShowProspekV2Response.fromJson(res.body);
      }
    } on TimeoutException catch (_) {
      EasyLoading.showError('Connection Timeout. Please try again later');
      EasyLoading.dismiss();
    } catch (exception) {
      print(exception);
    }
    return null;
  }
}
