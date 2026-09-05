// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Kranti Ganesh Mandal';

  @override
  String get appSubtitle => 'Saigaon';

  @override
  String get pledgeLedger => 'Pledge Ledger';

  @override
  String get pledgeLedgerSubtitle => 'Track vows & collections';

  @override
  String get cashbook => 'Cashbook';

  @override
  String get cashbookSubtitle => 'Received & paid';

  @override
  String get games => 'Games';

  @override
  String get gamesSubtitle => 'Festival competitions';

  @override
  String get mankari => 'Mankari';

  @override
  String get mankariSubtitle => 'Volunteer assignments';

  @override
  String get gallery => 'Gallery';

  @override
  String get gallerySubtitle => 'Photos & memories';

  @override
  String get reports => 'Reports';

  @override
  String get reportsSubtitle => 'Summaries & exports';

  @override
  String get noPledgesYet => 'No pledges yet';

  @override
  String get addPledgesMessage => 'Add pledges to track vows and collections.';

  @override
  String get completed => 'Completed';

  @override
  String get received => 'Received';

  @override
  String get pending => 'Pending';

  @override
  String get allStatuses => 'All';

  @override
  String get income => 'Received';

  @override
  String get expense => 'Paid';

  @override
  String teamsRegistered(int count) {
    return '$count teams registered';
  }

  @override
  String photosCount(int count) {
    return '$count photos';
  }

  @override
  String get pledgeSummary => 'Pledge Summary';

  @override
  String get pledgeSummaryDesc => 'Total pledges collected vs pending';

  @override
  String pledgeSummaryDetail(String collected, String pending) {
    return '$collected collected · $pending pending';
  }

  @override
  String get cashbookBalance => 'Cashbook Balance';

  @override
  String get cashbookBalanceDesc => 'Net balance after paid amounts';

  @override
  String cashbookBalanceDetail(String income, String expense) {
    return '$income received · $expense paid';
  }

  @override
  String get volunteerHours => 'Volunteer Hours';

  @override
  String get volunteerHoursDesc => 'Total mankari shifts logged';

  @override
  String get scheduled => 'Scheduled';

  @override
  String get inProgress => 'In Progress';

  @override
  String get language => 'Language';

  @override
  String get english => 'English';

  @override
  String get marathi => 'Marathi';

  @override
  String get gameTugOfWar => 'Tug of War';

  @override
  String get gameMatkiPhod => 'Matki Phod';

  @override
  String get gameRangoli => 'Rangoli Competition';

  @override
  String get shiftMorning => 'Morning';

  @override
  String get shiftEvening => 'Evening';

  @override
  String get shiftNight => 'Night';

  @override
  String get shiftAllDay => 'All Day';

  @override
  String get roleDecorationLead => 'Decoration Lead';

  @override
  String get roleFoodCommittee => 'Food Committee';

  @override
  String get roleSecurity => 'Security';

  @override
  String get roleCulturalEvents => 'Cultural Events';

  @override
  String get entryDonationPatil => 'Donation — Patil family';

  @override
  String get entryFlowerDecoration => 'Flower decoration';

  @override
  String get entryPledgeCollection => 'Pledge collection';

  @override
  String get entrySoundSystem => 'Sound system rental';

  @override
  String get albumVisarjan2025 => 'Visarjan';

  @override
  String get albumAartiCeremony => 'Aarti Ceremony';

  @override
  String get albumCulturalNight => 'Cultural Night';

  @override
  String get albumPranPratishtha => 'Pran Pratishtha';

  @override
  String get add => 'Add';

  @override
  String get save => 'Save';

  @override
  String get cancel => 'Cancel';

  @override
  String get name => 'Name';

  @override
  String get amount => 'Amount';

  @override
  String get date => 'Date';

  @override
  String get description => 'Description';

  @override
  String get addPledge => 'Add Pledge';

  @override
  String get addMankari => 'Add Volunteer';

  @override
  String get addGame => 'Add Game';

  @override
  String get addEntry => 'Add Entry';

  @override
  String get editEntry => 'Edit Entry';

  @override
  String get userName => 'User name';

  @override
  String get registeredMember => 'Member';

  @override
  String get cashbookCategory => 'Category';

  @override
  String get selectRegisteredMember => 'Select registered member';

  @override
  String get selectCategory => 'Select category';

  @override
  String get noRegisteredMembersAvailable =>
      'Add registered users in Admin first';

  @override
  String get categoryDecoration => 'Decoration';

  @override
  String get categoryDonation => 'Donation';

  @override
  String get categoryPooja => 'Pooja';

  @override
  String get categoryGaneshIdol => 'Ganesh Idol';

  @override
  String get categoryGaneshAagman => 'Ganesh Aagman';

  @override
  String get categoryGaneshVisarjan => 'Ganesh Visarjan';

  @override
  String get categoryPrasad => 'Prasad';

  @override
  String get categoryOthers => 'Others';

  @override
  String get fieldRequired => 'This field is required';

  @override
  String get invalidAmount => 'Enter a valid amount';

  @override
  String get invalidParticipants => 'Enter a valid participant count';

  @override
  String get selectDate => 'Select date';

  @override
  String get markAsCompleted => 'Mark as completed';

  @override
  String get noCashbookEntries => 'No entries yet';

  @override
  String get addCashbookMessage =>
      'Add received or paid entries to track cash flow.';

  @override
  String get tapStatusToToggle => 'Tap status to change';

  @override
  String get markedAsCompleted => 'Marked as completed';

  @override
  String get markedAsReceived => 'Marked as received';

  @override
  String get markAsReceived => 'Mark as received';

  @override
  String get markedAsPending => 'Marked as pending';

  @override
  String get totalAmount => 'Total amount';

  @override
  String get totalPending => 'Total Pending';

  @override
  String get totalReceived => 'Total Received';

  @override
  String get editPledge => 'Edit Pledge';

  @override
  String get editMankari => 'Edit Volunteer';

  @override
  String get editGame => 'Edit Game';

  @override
  String get status => 'Status';

  @override
  String get updatedAt => 'Updated at';

  @override
  String get useCurrentTime => 'Use current time';

  @override
  String get tapToEdit => 'Tap a pledge to edit';

  @override
  String get tapMankariToEdit => 'Tap a volunteer to edit';

  @override
  String get tapGameToEdit => 'Tap a game to edit';

  @override
  String get noGamesYet => 'No games yet';

  @override
  String get addGamesMessage => 'Add games to track participants and winners.';

  @override
  String get gameName => 'Game name';

  @override
  String get participants => 'Participants';

  @override
  String participantsCount(int count) {
    return '$count participants';
  }

  @override
  String get firstWinner => '1st Winner';

  @override
  String get secondWinner => '2nd Winner';

  @override
  String get thirdWinner => '3rd Winner';

  @override
  String get winnerOptionalHint => 'Optional';

  @override
  String get noVolunteersYet => 'No volunteers yet';

  @override
  String get addVolunteersMessage =>
      'Add mankari assignments to track volunteer shifts.';

  @override
  String get role => 'Role';

  @override
  String get shift => 'Shift';

  @override
  String get addPhoto => 'Add Photo';

  @override
  String get photoType => 'Photo type';

  @override
  String get photoYear => 'Year';

  @override
  String get allPhotoTypes => 'All types';

  @override
  String get allYears => 'All years';

  @override
  String get deletePhoto => 'Delete photo';

  @override
  String get deletePhotoConfirm => 'Delete this photo from the gallery?';

  @override
  String get photoDeleted => 'Photo deleted';

  @override
  String get noPhotosYet => 'No photos yet';

  @override
  String get addPhotosMessage =>
      'Upload photos and choose a type and year for your gallery.';

  @override
  String get uploadFailed => 'Could not upload photo';

  @override
  String get note => 'Note';

  @override
  String get noteHint => 'Optional short note';

  @override
  String get splashTitle => 'KRANTI GANESH SAIGAON';

  @override
  String get splashTitleMarathi => 'क्रांती गणेश सायगाव';

  @override
  String get login => 'Login';

  @override
  String get logout => 'Logout';

  @override
  String get mobileNumber => 'Mobile number';

  @override
  String get password => 'Password';

  @override
  String get invalidMobile => 'Enter a valid 10-digit mobile number';

  @override
  String get invalidPassword => 'Enter a valid 4 digit password';

  @override
  String get invalidCredentials => 'Invalid mobile number or password';

  @override
  String get accountInactive => 'This account is inactive. Contact an admin.';

  @override
  String get loginFailed => 'Login failed. Please try again.';

  @override
  String get readOnlyMode => 'Read-only access';

  @override
  String get admin => 'Admin';

  @override
  String get adminSubtitle => 'Manage users & roles';

  @override
  String get addUser => 'Add User';

  @override
  String get editUser => 'Edit User';

  @override
  String get deleteUser => 'Delete user';

  @override
  String get deleteUserConfirm => 'Delete this user?';

  @override
  String get deletePledge => 'Delete pledge';

  @override
  String get deletePledgeConfirm => 'Delete this pledge?';

  @override
  String get deleteEntry => 'Delete entry';

  @override
  String get deleteEntryConfirm => 'Delete this cashbook entry?';

  @override
  String get pledgeDeleted => 'Pledge deleted';

  @override
  String get entryDeleted => 'Entry deleted';

  @override
  String get noUsersYet => 'No users yet';

  @override
  String get addUsersMessage => 'Add users with name, mobile number, and role.';

  @override
  String get userRole => 'Role';

  @override
  String get roleAdmin => 'Admin';

  @override
  String get roleSuperAdmin => 'Super Admin';

  @override
  String get roleMember => 'Member';

  @override
  String get roleUser => 'User';

  @override
  String get userStatus => 'Status';

  @override
  String get userActive => 'Active';

  @override
  String get userInactive => 'Inactive';

  @override
  String get mobileAlreadyExists => 'This mobile number is already registered';

  @override
  String get cannotDeleteSelf => 'You cannot delete your own account';

  @override
  String get cannotDeleteSuperAdmin => 'Super Admin cannot be deleted';

  @override
  String get sendRegistrationWhatsApp => 'Send registration on WhatsApp?';

  @override
  String sendRegistrationWhatsAppMessage(String name) {
    return 'Open WhatsApp with a ready message for $name? You will need to tap Send.';
  }

  @override
  String get sendViaWhatsApp => 'Send on WhatsApp';

  @override
  String get skipForNow => 'Skip';

  @override
  String get whatsAppNotAvailable => 'Could not open WhatsApp on this device';

  @override
  String registrationWhatsAppBody(
    String name,
    String appName,
    String mobile,
    String password,
  ) {
    return 'Hello $name,\n\nYou are registered on $appName app.\n\nLogin details:\nMobile: $mobile\nPassword: $password\n\n— $appName';
  }
}
