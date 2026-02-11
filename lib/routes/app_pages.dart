import 'package:get/get.dart';
import 'package:staffku/modules/agent/bindings/agent_binding.dart';
import 'package:staffku/modules/agent/views/add_agent_view.dart';
import 'package:staffku/modules/agent/views/agent_view.dart';
import 'package:staffku/modules/agent/views/detail_agent_view.dart';
import 'package:staffku/modules/cuti/bindings/cuti_binding.dart';
import 'package:staffku/modules/cuti/views/add_cuti_view.dart';
import 'package:staffku/modules/cuti/views/detail_cuti_view.dart';
import 'package:staffku/modules/cuti/views/list_cuti.dart';
import 'package:staffku/modules/input/bindings/input_binding.dart';
import 'package:staffku/modules/input/views/add_input_view.dart';
import 'package:staffku/modules/kuisioner/bindings/kuisioner_binding.dart';
import 'package:staffku/modules/kuisioner/views/add_kuisioner_view.dart';
import 'package:staffku/modules/kuisioner/views/input_data_kuisioner_view.dart';
import 'package:staffku/modules/leads/bindings/leads_binding.dart';
import 'package:staffku/modules/leads/views/add_leads_view.dart';
import 'package:staffku/modules/leads/views/detail_leads_view.dart';
import 'package:staffku/modules/leads/views/leads_view.dart';
import 'package:staffku/modules/leave/bindings/leave_binding.dart';
import 'package:staffku/modules/leave/views/add_leave_view.dart';
import 'package:staffku/modules/leave/views/detail_leave_view.dart';
import 'package:staffku/modules/leave/views/leave_view.dart';
import 'package:staffku/modules/overtime/bindings/overtime_binding.dart';
import 'package:staffku/modules/overtime/views/add_overtime_view.dart';
import 'package:staffku/modules/overtime/views/detail_overtime_view.dart';
import 'package:staffku/modules/overtime/views/leave_overtime.dart';
import 'package:staffku/modules/prospek/bindings/prospek_binding.dart';
import 'package:staffku/modules/prospek/views/add_prospek_view.dart';
import 'package:staffku/modules/prospek/views/detail_prospek_view.dart';
import 'package:staffku/modules/prospek/views/prospek_view.dart';
import 'package:staffku/modules/prospek_v2/bindings/prospek_v2_binding.dart';
import 'package:staffku/modules/prospek_v2/views/add_prospek_view.dart';
import 'package:staffku/modules/prospek_v2/views/prospek_view.dart';
import 'package:staffku/modules/store/bindings/store_binding.dart';
import 'package:staffku/modules/store/views/detail_store_view.dart';
import 'package:staffku/modules/store/views/result_kunjungan.dart';
import 'package:staffku/modules/store/views/store_view.dart';
import 'package:staffku/modules/claim/bindings/claim_binding.dart';
import 'package:staffku/modules/claim/views/add_claim_view.dart';
import 'package:staffku/modules/claim/views/claim_view.dart';
import 'package:staffku/modules/claim/views/detail_claim_view.dart';
import 'package:staffku/modules/payslip/bindings/payslip_binding.dart';
import 'package:staffku/modules/payslip/views/payslip_view.dart';
import 'package:staffku/modules/shift_swap/bindings/shift_swap_binding.dart';
import 'package:staffku/modules/shift_swap/views/add_shift_swap_view.dart';
import 'package:staffku/modules/shift_swap/views/detail_shift_swap_view.dart';
import 'package:staffku/modules/shift_swap/views/shift_swap_view.dart';
import 'package:staffku/modules/sos/bindings/sos_binding.dart';
import 'package:staffku/modules/sos/views/add_sos_view.dart';
import 'package:staffku/modules/sos/views/sos_detail_view.dart';
import 'package:staffku/modules/sos/views/sos_list_view.dart';
import 'package:staffku/modules/sos/views/sos_sample_view.dart';

import '../modules/notification/bindings/notification_binding.dart';
import '../modules/notification/views/notification_view.dart';
import '../modules/absensi/bindings/absensi_binding.dart';
import '../modules/absensi/views/absensi_view.dart';
import '../modules/auth/auth.dart';
import '../modules/home/attendance/attendance_binding.dart';
import '../modules/home/home.dart';
import '../modules/modules.dart';
import '../modules/recap/bindings/recap_binding.dart';
import '../modules/recap/views/recap_view.dart';
import '../modules/event/bindings/event_binding.dart';
import '../modules/event/views/event_detail_view.dart';
import '../modules/event/views/event_view.dart';

part 'app_routes.dart';

class AppPages {
  static const INITIAL = Routes.SPLASH;

  static final routes = [
    GetPage(
      name: Routes.SPLASH,
      page: () => SplashScreen(),
      binding: SplashBinding(),
    ),
    // GetPage(
    //   name: Routes.AUTH,
    //   page: () => AuthScreen(),
    //   binding: AuthBinding(),
    //   children: [
    //     GetPage(name: Routes.REGISTER, page: () => RegisterScreen()),
    //     GetPage(name: Routes.LOGIN, page: () => LoginScreen()),
    //   ],
    // ),
    GetPage(
      name: Routes.LOGIN,
      page: () => LoginScreen(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: Routes.HOME,
      page: () => HomeScreen(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: Routes.LEAVE,
      page: () => LeaveView(),
      binding: LeaveBinding(),
    ),
    GetPage(
      name: Routes.ADD_LEAVE,
      page: () => AddLeaveView(),
      binding: LeaveBinding(),
    ),
    GetPage(
      name: Routes.DETAIL_LEAVE,
      page: () => LeaveDetailView(),
      binding: LeaveBinding(),
    ),
    GetPage(
      name: Routes.PROSPEK,
      page: () => ProspekView(),
      binding: LemburBinding(),
    ),
    GetPage(
      name: Routes.ADD_PROSPEK,
      page: () => ProspekAddView(),
      binding: LemburBinding(),
    ),
    GetPage(
      name: Routes.DETAIL_PROSPEK,
      page: () => ProspekDetailView(),
      binding: LemburBinding(),
    ),
    GetPage(
      name: Routes.ABSENSI,
      page: () => AbsensiView(),
      binding: AbsensiBinding(),
    ),
    GetPage(
      name: Routes.RECAP,
      page: () => RecapView(),
      binding: RecapBinding(),
    ),
    GetPage(
      name: Routes.DISCOVER_TAB,
      page: () => DiscoverTab(),
      binding: AttendanceBinding(),
    ),
    GetPage(
      name: Routes.EVENT,
      page: () => EventView(),
      binding: EventBinding(),
    ),
    GetPage(
      name: Routes.DETAIL_EVENT,
      page: () => ReliverDetailView(),
      binding: EventBinding(),
    ),
    GetPage(
      name: Routes.NOTIFICATION,
      page: () => NotificationView(),
      binding: NotificationBinding(),
    ),
    GetPage(
      name: Routes.INPUT,
      page: () => AddInputView(),
      binding: InputBinding(),
    ),
    GetPage(
      name: Routes.STORE,
      page: () => StoreView(),
      binding: StoreBinding(),
    ),
    GetPage(
      name: Routes.DETAIL_STORE,
      page: () => StoreDetailView(),
      binding: StoreBinding(),
    ),
    GetPage(
      name: Routes.KUISIONER,
      page: () => AddKuisionerView(),
      binding: KusionerBinding(),
    ),
    GetPage(
      name: Routes.RESULT_KUNJUNGAN,
      page: () => ResultKunjunganView(),
      binding: StoreBinding(),
    ),
    GetPage(
      name: Routes.OVERTIME,
      page: () => OvertimeView(),
      binding: OvertimeBinding(),
    ),
    GetPage(
      name: Routes.ADD_OVERTIME,
      page: () => AddOvertimeView(),
      binding: OvertimeBinding(),
    ),
    GetPage(
      name: Routes.DETAIL_OVERTIME,
      page: () => OvertimeDetailView(),
      binding: OvertimeBinding(),
    ),
    GetPage(
      name: Routes.LEADS,
      page: () => LeadsView(),
      binding: LeadsBinding(),
    ),
    GetPage(
      name: Routes.ADD_LEADS,
      page: () => AddLeadsView(),
      binding: LeadsBinding(),
    ),
    GetPage(
      name: Routes.DETAIL_LEADS,
      page: () => LeadsDetailView(),
      binding: LeadsBinding(),
    ),
    GetPage(
      name: Routes.INPUT_DATA_KUISIONER,
      page: () => InputDataKuisionerView(),
      binding: KusionerBinding(),
    ),
    GetPage(name: Routes.CUTI, page: () => CutiView(), binding: CutiBinding()),
    GetPage(
      name: Routes.ADD_CUTI_SALES,
      page: () => AddCutiView(),
      binding: CutiBinding(),
    ),
    GetPage(
      name: Routes.DETAIL_CUTI_SALES,
      page: () => CutiDetailView(),
      binding: CutiBinding(),
    ),
    GetPage(
      name: Routes.PROSPEK_V2,
      page: () => ProspekV2View(),
      binding: ProspekV2Binding(),
    ),
    GetPage(
      name: Routes.ADD_PROSPEK_V2,
      page: () => ProspekV2AddView(),
      binding: ProspekV2Binding(),
    ),
    GetPage(
      name: Routes.AGENT,
      page: () => AgentView(),
      binding: AgentBinding(),
    ),
    GetPage(
      name: Routes.ADD_AGENT,
      page: () => AddAgentView(),
      binding: AgentBinding(),
    ),
    GetPage(
      name: Routes.DETAIL_AGENT,
      page: () => AgentDetailView(),
      binding: AgentBinding(),
    ),
    GetPage(
      name: Routes.SHIFT_SWAP,
      page: () => const ShiftSwapView(),
      binding: ShiftSwapBinding(),
    ),
    GetPage(
      name: Routes.ADD_SHIFT_SWAP,
      page: () => const AddShiftSwapView(),
      binding: ShiftSwapBinding(),
    ),
    GetPage(
      name: Routes.DETAIL_SHIFT_SWAP,
      page: () => const ShiftSwapDetailView(),
      binding: ShiftSwapBinding(),
    ),
    GetPage(
      name: Routes.CLAIM,
      page: () => const ClaimView(),
      binding: ClaimBinding(),
    ),
    GetPage(
      name: Routes.ADD_CLAIM,
      page: () => const AddClaimView(),
      binding: ClaimBinding(),
    ),
    GetPage(
      name: Routes.DETAIL_CLAIM,
      page: () => const ClaimDetailView(),
      binding: ClaimBinding(),
    ),
    GetPage(
      name: Routes.PAYSLIP,
      page: () => const PayslipView(),
      binding: PayslipBinding(),
    ),
    GetPage(
      name: Routes.SOS,
      page: () => const SosListView(),
      binding: SosBinding(),
    ),
    GetPage(
      name: Routes.ADD_SOS,
      page: () => const AddSosView(),
      binding: SosBinding(),
    ),
    GetPage(
      name: Routes.DETAIL_SOS,
      page: () => const SosDetailView(),
      binding: SosBinding(),
    ),
    GetPage(
      name: Routes.SOS_SAMPLE,
      page: () => const SosSampleView(),
    ),
  ];
}
