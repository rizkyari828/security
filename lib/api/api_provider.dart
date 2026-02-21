import 'dart:typed_data';

import 'package:staffku/api/base_provider.dart';
import 'package:staffku/models/models.dart';
import 'package:staffku/models/request/agent/submit_agent.dart';
import 'package:staffku/models/request/attendance/attendance_wrapper.dart';
import 'package:staffku/models/request/attendance/submit_attendance.dart';
import 'package:staffku/models/request/attendance/validate_attenance.dart';
import 'package:staffku/models/request/benefit_request.dart';
import 'package:staffku/models/request/claim/detail_claim_request.dart';
import 'package:staffku/models/request/claim/list_claim_request.dart';
import 'package:staffku/models/request/claim/submit_claim_request.dart';
import 'package:staffku/models/request/claim/update_approval_claim_request.dart';
import 'package:staffku/models/request/cuti/submit_cuti_request.dart';
import 'package:staffku/models/request/cuti/update_approval_request.dart';
import 'package:staffku/models/request/cuti_sales/detail_request_cuti.dart';
import 'package:staffku/models/request/cuti_sales/submit_izin_request.dart';
import 'package:staffku/models/request/cuti_sales/update_approval_request.dart';
import 'package:staffku/models/request/dashboard_request.dart';
import 'package:staffku/models/request/detail_request.dart';
import 'package:staffku/models/request/detail_request_leave.dart';
import 'package:staffku/models/request/id_request.dart';
import 'package:staffku/models/request/input_request.dart';
import 'package:staffku/models/request/face/save_face_request.dart';
import 'package:staffku/models/request/izin/submit_izin_request.dart';
import 'package:staffku/models/request/izin/update_approval_request.dart';
import 'package:staffku/models/request/kuisioner/kuisioner_input_data_request.dart';
import 'package:staffku/models/request/kuisioner/kuisioner_request.dart';
import 'package:staffku/models/request/kunjungan/non_schedule_request.dart';
import 'package:staffku/models/request/leads/submit_lead.dart';
import 'package:staffku/models/request/leads/submit_status_lead.dart';
import 'package:staffku/models/request/lembur/detail_request_lembur.dart';
import 'package:staffku/models/request/lembur/submit_izin_request.dart';
import 'package:staffku/models/request/lembur/update_approval_request.dart';
import 'package:staffku/models/request/logout_request.dart';
import 'package:staffku/models/request/overtime/get_list.dart';
import 'package:staffku/models/request/overtime/set_done_overtime_request.dart';
import 'package:staffku/models/request/overtime/submit_overtime_client_request.dart';
import 'package:staffku/models/request/overtime/submit_request_overtime.dart';
import 'package:staffku/models/request/overtime/update_approval_overtime_request.dart';
import 'package:staffku/models/request/pagination_request.dart';
import 'package:staffku/models/request/payslip/download_payslip_request.dart';
import 'package:staffku/models/request/prospek_v2/detail_request_cuti.dart';
import 'package:staffku/models/request/prospek_v2/submit_request_prospek_v2.dart';
import 'package:staffku/models/request/rate/submit_rate_request.dart';
import 'package:staffku/models/request/reliver/approve_reliver_request.dart';
import 'package:staffku/models/request/reliver/create_reliver_request.dart';
import 'package:staffku/models/request/patroli/patroli_id_request.dart';
import 'package:staffku/models/request/patroli/patroli_list_request.dart';
import 'package:staffku/models/request/patroli/submit_patroli_request.dart';
import 'package:staffku/models/request/store/detail_request_leave.dart';
import 'package:staffku/models/request/store/update_qty_request.dart';
import 'package:staffku/models/request/submit_mood_request.dart';
import 'package:staffku/models/request/shift_swap/detail_shift_request.dart';
import 'package:staffku/models/request/shift_swap/list_shift_request.dart';
import 'package:staffku/models/request/shift_swap/simpan_shift_request.dart';
import 'package:staffku/models/request/shift_swap/approve_shift_request.dart';
import 'package:staffku/models/request/sos/list_sos_request.dart';
import 'package:staffku/models/request/sos/submit_sos_request.dart';
import 'package:staffku/models/request/update_fcm_profile_request.dart';
import 'package:staffku/models/request/update_photo_profile_request.dart';
import 'package:get/get.dart';
import 'package:staffku/models/request/user_id_request.dart';

class ApiProvider extends BaseProvider {
  Future<Response> login(String path, LoginRequest data) {
    return post(
      path,
      data.toJson(),
      contentType: 'application/json',
      headers: const {'accept': 'application/json'},
    );
  }

  Future<Response> logout(String path, LogoutRequest data) {
    return post(path, data.toJson());
  }

  Future<Response> register(String path, RegisterRequest data) {
    return post(path, data.toJson());
  }

  Future<Response> getUsers(String path) {
    return get(path);
  }

  Future<Response> getUserSchedule(String path) {
    return get(path);
  }

  Future<Response> getRecapHistory(String path, IdRequest data) {
    return post(path, data.toJson());
  }

  Future<Response> submitAttendance(
    String path,
    AttendanceSubmitRequest data,
  ) async {
    try {
      print(data.toFormData().fields);
      print(data.toJson());

      final response = await post(
        path,
        data.toFormData(),
        contentType: "multipart/form-data",
      );
      return response;
    } catch (e, stackTrace) {
      print('Error saat submit attendance: $e');
      print('Stack trace: $stackTrace');
      rethrow; // atau bisa juga return Future.error(e); tergantung kebutuhan
    }
  }

  Future<Response> validateAttendance(
    String path,
    AttendanceValidateRequest request,
  ) {
    return post(path, request.toJson());
  }

  //START OVERTIME
  Future<Response> getProspek(String path, GetListRequest data) {
    print(data.toJson());
    return post(path, data.toJson());
  }

  Future<Response> getShowProspek(String path, GetListRequest data) {
    return post(path, data.toJson());
  }

  Future<Response> submitOvertime(String path, SubmitOvertimeRequest data) {
    print(data.toJson());
    return post(path, data.toJson());
  }

  Future<Response> submitOvertimeClient(
    String path,
    SubmitOvertimeClientRequest data,
  ) {
    return post(path, data.toJson());
  }

  Future<Response> setDoneOvertime(String path, SetDoneOvertimeRequest data) {
    return patch(path, data.toJson());
  }

  Future<Response> updateApprovalOvertime(
    String path,
    UpdateApprovalOvertimeRequest data,
  ) {
    print(data.toJson());
    return post(path, data.toJson());
  }

  Future<Response> getMasterData(String path) {
    return get(path);
  }
  //END OVERTIME

  //START BENEFIT
  Future<Response> getBenefit(String path, BenefitRequest data) {
    return post(path, data.toJson());
  }

  Future<Response> getBenefitDashboard(String path, IdRequest data) {
    return post(path, data.toJson());
  }

  Future<Response> getTypeCuti(String path) {
    return get(path);
  }

  Future<Response> getShowCuti(String path) {
    print(path);
    return get(path);
  }

  Future<Response> submitCuti(String path, SubmitCutiRequest data) {
    return post(path, data.toJson());
  }

  Future<Response> updateCuti(String path, SubmitCutiRequest data) {
    return patch(path, data.toJson());
  }

  Future<Response> updateApprovalCuti(
    String path,
    UpdateApprovalCutiRequest data,
  ) {
    return patch(path, data.toJson());
  }
  //END BENEFIT

  //START IZIN
  Future<Response> getIzin(String path, IdRequest data) {
    return post(path, data.toJson());
  }

  Future<Response> getTypeIzin(String path) {
    return get(path);
  }

  Future<Response> getShowIzin(String path, ShowLeaveRequest data) {
    return post(path, data.toJson());
  }

  Future<Response> submitIzin(String path, SubmitIzinRequest data) {
    return post(path, data.toJson());
  }

  Future<Response> updateIzin(String path, SubmitIzinRequest data) {
    return patch(path, data.toJson());
  }

  Future<Response> updateApprovalIzin(
    String path,
    UpdateApprovalIzinRequest data,
  ) {
    return patch(path, data.toJson());
  }
  //ENDIZIN

  //START IZIN
  Future<Response> getReliver(String path) {
    return get(path);
  }

  Future<Response> getShowReliver(String path, ShowEventRequest data) {
    return post(path, data.toJson());
  }

  Future<Response> submitReliver(String path, CreateReliverRequest data) {
    return post(path, data.toJson());
  }

  Future<Response> updateApprovalReliver(
    String path,
    ApproveReliverRequest data,
  ) {
    return patch(path, data.toJson());
  }
  //ENDIZIN

  //START TASKLIST
  Future<Response> getTaskList(String path) {
    return get(path);
  }

  Future<Response> getShowTaskList(String path) {
    print(path);
    return get(path);
  }

  Future<Response> deleteTaskList(String path) {
    return delete(path);
  }

  Future<Response> getType(String path) {
    return get(path);
  }

  Future<Response> getTaskName(String path) {
    return get(path);
  }

  Future<Response> getBranchList(String path) {
    return get(path);
  }

  Future<Response> listTaskListTadKorlap(String path) {
    return get(path);
  }

  Future<Response> showTaskListTadKorlap(String path) {
    return get(path);
  }

  Future<Response> saveFace(String path, SaveFaceRequest data) {
    print(data.toFormData().fields);
    return post(path, data.toFormData(), contentType: 'multipart/form-data');
  }

  Future<Response> updateFcmProfile(String path, UpdateFcmProfileRequest data) {
    print(data.toFormData().fields);
    return post(path, data.toFormData(), contentType: 'multipart/form-data');
  }

  Future<Response> updatePhotoProfile(
    String path,
    UpdatePhotoProfileRequest data,
  ) {
    print(data.toJson());
    return patch(path, data.toJson());
  }

  Future<Response> getRate(String path) {
    return get(path);
  }

  Future<Response> submitRate(String path, SubmitRate data) {
    print(data.toJson());
    return patch(path, data.toJson());
  }

  Future<Response> submitInput(String path, SubmitInputRequest data) {
    print(data.toJson());
    return post(path, data.toJson());
  }

  Future<Response> submitKuisioner(String path, SubmitKuisionerRequest data) {
    print(data.toJson());
    return post(path, data.toJson());
  }

  Future<Response> submitInputDataKuisioner(
    String path,
    KuisionerInputDataRequest data,
  ) {
    print(data.toJson());
    return post(path, data.toJson());
  }

  // Future<Response> getStore(String path, UserIdRequest data) {
  //   return post(path, data.toJson());
  // }

  Future<Response> getStore(String path) {
    return get(path);
  }

  Future<Response> submitQtyInput(String path, QtyUpdateRequest data) {
    print(data.toJson());
    return post(path, data.toJson());
  }

  Future<Response> getKuisioner(String path, ListKuisionerRequest data) {
    return post(path, data.toJson());
  }

  //START IZIN
  Future<Response> getLembur(String path, UserIdRequest data) {
    return post(path, data.toJson());
  }

  Future<Response> getTypeLembur(String path) {
    return get(path);
  }

  Future<Response> getShowLembur(String path, ShowLemburRequest data) {
    return post(path, data.toJson());
  }

  Future<Response> submitLembur(String path, SubmitLemburRequest data) {
    print(data.toJson());
    return post(path, data.toJson());
  }

  Future<Response> updateLembur(String path, SubmitLemburRequest data) {
    return post(path, data.toJson());
  }

  Future<Response> updateApprovalLembur(
    String path,
    UpdateApprovalLemburRequest data,
  ) {
    return post(path, data.toJson());
  }

  Future<Response> submitDialogMood(String path, SubmitDialogMoodRequest data) {
    return post(path, data.toJson());
  }
  //ENDIZIN

  Future<Response> submitKunjungan(
    String path,
    AttendanceSubmitRequestWrapper data,
  ) async {
    try {
      print(data.toJson());
      // Kirim sebagai JSON, bukan multipart
      final response = await post(path, data.toJson());
      return response;
    } catch (e, stackTrace) {
      print('Error saat submit attendance: $e');
      print('Stack trace: $stackTrace');
      rethrow;
    }
  }

  Future<Response> submitNonKunjungan(
    String path,
    NonScheduleSubmitRequest data,
  ) async {
    try {
      print(data.toJson());
      // Kirim sebagai JSON, bukan multipart
      final response = await post(path, data.toJson());
      return response;
    } catch (e, stackTrace) {
      print('Error saat submit attendance: $e');
      print('Stack trace: $stackTrace');
      rethrow;
    }
  }

  Future<Response> submitLead(String path, SubmitLeadRequest data) {
    return post(path, data.toJson());
  }

  Future<Response> submitStatusLead(String path, SubmitStatusLeadRequest data) {
    return post(path, data.toJson());
  }

  Future<Response> getLeads(String path, UserIdRequest data) {
    return post(path, data.toJson());
  }

  Future<Response> getShowKunjungan(
    String path,
    ShowDetailKunjunganRequest data,
  ) {
    print(data.toJson());
    return post(path, data.toJson());
  }

  //START CUTI
  Future<Response> getCutiSales(String path, UserIdRequest data) {
    return post(path, data.toJson());
  }

  Future<Response> getShowCutiSales(String path, ShowCutiSalesRequest data) {
    return post(path, data.toJson());
  }

  Future<Response> submitCutiSales(String path, SubmitCutiSalesRequest data) {
    print(data.toJson());
    return post(path, data.toJson());
  }

  Future<Response> updateCutiSales(String path, SubmitCutiSalesRequest data) {
    return post(path, data.toJson());
  }

  Future<Response> updateApprovalCutiSales(
    String path,
    UpdateApprovalCutiSalesRequest data,
  ) {
    return post(path, data.toJson());
  }
  //ENDIZIN

  //START SHIFT SWAP
  Future<Response> listShift(String path, ListShiftRequest data) {
    return post(
      path,
      data.toFormData(),
      contentType: 'multipart/form-data',
    );
  }

  Future<Response> detailShift(String path, DetailShiftRequest data) {
    return post(
      path,
      data.toFormData(),
      contentType: 'multipart/form-data',
    );
  }

  Future<Response> simpanShift(String path, SimpanShiftRequest data) {
    return post(
      path,
      data.toFormData(),
      contentType: 'multipart/form-data',
    );
  }

  Future<Response> approveShift(String path, ApproveShiftRequest data) {
    return post(
      path,
      data.toFormData(),
      contentType: 'multipart/form-data',
    );
  }

  Future<Response> getShiftOptions(String path) => get(path);
  //END SHIFT SWAP

  //START CLAIM
  Future<Response> getClaim(String path, ListClaimRequest data) {
    return post(
      path,
      data.toFormData(),
      contentType: 'multipart/form-data',
    );
  }

  Future<Response> getShowClaim(String path, ShowClaimRequest data) {
    return post(
      path,
      data.toFormData(),
      contentType: 'multipart/form-data',
    );
  }

  Future<Response> submitClaim(String path, SubmitClaimRequest data) {
    return post(
      path,
      data.toFormData(),
      contentType: 'multipart/form-data',
    );
  }

  Future<Response> updateApprovalClaim(
    String path,
    UpdateApprovalClaimRequest data,
  ) {
    return post(path, data.toJson());
  }
  //END CLAIM

  //START SOS
  Future<Response> listSos(String path, ListSosRequest data) {
    return post(
      path,
      data.toJson(),
      contentType: 'application/json',
      headers: const {'accept': 'application/json'},
    );
  }

  Future<Response> submitSos(String path, SubmitSosRequest data) {
    return post(
      path,
      data.toFormData(),
      contentType: 'multipart/form-data',
    );
  }
  //END SOS

  //START PAYSLIP
  Future<Response> downloadPayslipExcel(
    String path,
    DownloadPayslipRequest data,
  ) {
    final uri = Uri.parse(path).replace(queryParameters: data.toQuery());
    return get(uri.toString(), headers: const {'X-Show-Error': '1'});
  }

  Future<Response> downloadPayslipPdf(
    String path,
    DownloadPayslipRequest data,
  ) {
    return post(
      path,
      data.toListPayslipJson(),
      contentType: 'application/json',
      headers: const {'X-Show-Error': '1', 'accept': 'application/json'},
    );
  }

  Future<Response> downloadFileFromUrl(String url) {
    return httpClient.get<Uint8List>(
      url,
      headers: const {'X-Show-Error': '1', 'accept': 'application/pdf'},
      responseInterceptor: (request, _, response) async {
        final headers = <String, String>{};
        response.headers.forEach((key, values) {
          headers[key] = values.join(',');
        });

        final builder = BytesBuilder(copy: false);
        await for (final chunk in response) {
          builder.add(chunk);
        }
        final bytes = builder.takeBytes();

        return Response<Uint8List>(
          headers: headers,
          statusCode: response.statusCode,
          statusText: response.reasonPhrase,
          body: bytes,
        );
      },
    );
  }
  //END PAYSLIP

  Future<Response> getDashboard(String path) {
    return get(path);
  }

  Future<Response> getDashboardKunjungan(String path, DashboardRequest data) {
    print(data.toJson());
    return post(path, data.toJson());
  }

  Future<Response> getShowProspekV2(String path, ShowProspectV2Request data) {
    return post(path, data.toJson());
  }

  Future<Response> submitProspectV2(String path, SubmitProspekV2Request data) {
    print(data.toJson());
    return post(path, data.toJson());
  }

  Future<Response> getProspekV2(String path, UserIdRequest data) {
    print(data.toJson());
    return post(path, data.toJson());
  }

  Future<Response> submitAgent(String path, SubmitAgentRequest data) {
    return post(path, data.toJson());
  }

  Future<Response> getAgent(String path, UserIdRequest data) {
    return post(path, data.toJson());
  }

  Future<Response> listMenu(String path, UserIdRequest data) {
    return post(
      path,
      data.toJson(),
      contentType: 'application/json',
      headers: const {'accept': 'application/json'},
    );
  }

  Future<Response> submitPatroli(String path, SubmitPatroliRequest data) {
    return post(
      path,
      data.toFormData(),
      contentType: 'multipart/form-data',
    );
  }

  Future<Response> detailPatroli(String path, PatroliIdRequest data) {
    return post(
      path,
      data.toFormData(),
      contentType: 'multipart/form-data',
    );
  }

  Future<Response> listPatroli(String path, PatroliListRequest data) {
    return post(
      path,
      data.toFormData(),
      contentType: 'multipart/form-data',
    );
  }
}
