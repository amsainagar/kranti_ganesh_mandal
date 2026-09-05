import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_mr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('mr'),
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'Kranti Ganesh Mandal'**
  String get appName;

  /// No description provided for @appSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Saigaon'**
  String get appSubtitle;

  /// No description provided for @pledgeLedger.
  ///
  /// In en, this message translates to:
  /// **'Pledge Ledger'**
  String get pledgeLedger;

  /// No description provided for @pledgeLedgerSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Track vows & collections'**
  String get pledgeLedgerSubtitle;

  /// No description provided for @cashbook.
  ///
  /// In en, this message translates to:
  /// **'Cashbook'**
  String get cashbook;

  /// No description provided for @cashbookSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Received & paid'**
  String get cashbookSubtitle;

  /// No description provided for @games.
  ///
  /// In en, this message translates to:
  /// **'Games'**
  String get games;

  /// No description provided for @gamesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Festival competitions'**
  String get gamesSubtitle;

  /// No description provided for @mankari.
  ///
  /// In en, this message translates to:
  /// **'Mankari'**
  String get mankari;

  /// No description provided for @mankariSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Volunteer assignments'**
  String get mankariSubtitle;

  /// No description provided for @gallery.
  ///
  /// In en, this message translates to:
  /// **'Gallery'**
  String get gallery;

  /// No description provided for @gallerySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Photos & memories'**
  String get gallerySubtitle;

  /// No description provided for @reports.
  ///
  /// In en, this message translates to:
  /// **'Reports'**
  String get reports;

  /// No description provided for @reportsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Summaries & exports'**
  String get reportsSubtitle;

  /// No description provided for @noPledgesYet.
  ///
  /// In en, this message translates to:
  /// **'No pledges yet'**
  String get noPledgesYet;

  /// No description provided for @addPledgesMessage.
  ///
  /// In en, this message translates to:
  /// **'Add pledges to track vows and collections.'**
  String get addPledgesMessage;

  /// No description provided for @completed.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get completed;

  /// No description provided for @received.
  ///
  /// In en, this message translates to:
  /// **'Received'**
  String get received;

  /// No description provided for @pending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get pending;

  /// No description provided for @allStatuses.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get allStatuses;

  /// No description provided for @income.
  ///
  /// In en, this message translates to:
  /// **'Received'**
  String get income;

  /// No description provided for @expense.
  ///
  /// In en, this message translates to:
  /// **'Paid'**
  String get expense;

  /// No description provided for @teamsRegistered.
  ///
  /// In en, this message translates to:
  /// **'{count} teams registered'**
  String teamsRegistered(int count);

  /// No description provided for @photosCount.
  ///
  /// In en, this message translates to:
  /// **'{count} photos'**
  String photosCount(int count);

  /// No description provided for @pledgeSummary.
  ///
  /// In en, this message translates to:
  /// **'Pledge Summary'**
  String get pledgeSummary;

  /// No description provided for @pledgeSummaryDesc.
  ///
  /// In en, this message translates to:
  /// **'Total pledges collected vs pending'**
  String get pledgeSummaryDesc;

  /// No description provided for @pledgeSummaryDetail.
  ///
  /// In en, this message translates to:
  /// **'{collected} collected · {pending} pending'**
  String pledgeSummaryDetail(String collected, String pending);

  /// No description provided for @cashbookBalance.
  ///
  /// In en, this message translates to:
  /// **'Cashbook Balance'**
  String get cashbookBalance;

  /// No description provided for @cashbookBalanceDesc.
  ///
  /// In en, this message translates to:
  /// **'Net balance after paid amounts'**
  String get cashbookBalanceDesc;

  /// No description provided for @cashbookBalanceDetail.
  ///
  /// In en, this message translates to:
  /// **'{income} received · {expense} paid'**
  String cashbookBalanceDetail(String income, String expense);

  /// No description provided for @volunteerHours.
  ///
  /// In en, this message translates to:
  /// **'Volunteer Hours'**
  String get volunteerHours;

  /// No description provided for @volunteerHoursDesc.
  ///
  /// In en, this message translates to:
  /// **'Total mankari shifts logged'**
  String get volunteerHoursDesc;

  /// No description provided for @scheduled.
  ///
  /// In en, this message translates to:
  /// **'Scheduled'**
  String get scheduled;

  /// No description provided for @inProgress.
  ///
  /// In en, this message translates to:
  /// **'In Progress'**
  String get inProgress;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @marathi.
  ///
  /// In en, this message translates to:
  /// **'Marathi'**
  String get marathi;

  /// No description provided for @gameTugOfWar.
  ///
  /// In en, this message translates to:
  /// **'Tug of War'**
  String get gameTugOfWar;

  /// No description provided for @gameMatkiPhod.
  ///
  /// In en, this message translates to:
  /// **'Matki Phod'**
  String get gameMatkiPhod;

  /// No description provided for @gameRangoli.
  ///
  /// In en, this message translates to:
  /// **'Rangoli Competition'**
  String get gameRangoli;

  /// No description provided for @shiftMorning.
  ///
  /// In en, this message translates to:
  /// **'Morning'**
  String get shiftMorning;

  /// No description provided for @shiftEvening.
  ///
  /// In en, this message translates to:
  /// **'Evening'**
  String get shiftEvening;

  /// No description provided for @shiftNight.
  ///
  /// In en, this message translates to:
  /// **'Night'**
  String get shiftNight;

  /// No description provided for @shiftAllDay.
  ///
  /// In en, this message translates to:
  /// **'All Day'**
  String get shiftAllDay;

  /// No description provided for @roleDecorationLead.
  ///
  /// In en, this message translates to:
  /// **'Decoration Lead'**
  String get roleDecorationLead;

  /// No description provided for @roleFoodCommittee.
  ///
  /// In en, this message translates to:
  /// **'Food Committee'**
  String get roleFoodCommittee;

  /// No description provided for @roleSecurity.
  ///
  /// In en, this message translates to:
  /// **'Security'**
  String get roleSecurity;

  /// No description provided for @roleCulturalEvents.
  ///
  /// In en, this message translates to:
  /// **'Cultural Events'**
  String get roleCulturalEvents;

  /// No description provided for @entryDonationPatil.
  ///
  /// In en, this message translates to:
  /// **'Donation — Patil family'**
  String get entryDonationPatil;

  /// No description provided for @entryFlowerDecoration.
  ///
  /// In en, this message translates to:
  /// **'Flower decoration'**
  String get entryFlowerDecoration;

  /// No description provided for @entryPledgeCollection.
  ///
  /// In en, this message translates to:
  /// **'Pledge collection'**
  String get entryPledgeCollection;

  /// No description provided for @entrySoundSystem.
  ///
  /// In en, this message translates to:
  /// **'Sound system rental'**
  String get entrySoundSystem;

  /// No description provided for @albumVisarjan2025.
  ///
  /// In en, this message translates to:
  /// **'Visarjan'**
  String get albumVisarjan2025;

  /// No description provided for @albumAartiCeremony.
  ///
  /// In en, this message translates to:
  /// **'Aarti Ceremony'**
  String get albumAartiCeremony;

  /// No description provided for @albumCulturalNight.
  ///
  /// In en, this message translates to:
  /// **'Cultural Night'**
  String get albumCulturalNight;

  /// No description provided for @albumPranPratishtha.
  ///
  /// In en, this message translates to:
  /// **'Pran Pratishtha'**
  String get albumPranPratishtha;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @amount.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get amount;

  /// No description provided for @date.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get date;

  /// No description provided for @description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// No description provided for @addPledge.
  ///
  /// In en, this message translates to:
  /// **'Add Pledge'**
  String get addPledge;

  /// No description provided for @addMankari.
  ///
  /// In en, this message translates to:
  /// **'Add Volunteer'**
  String get addMankari;

  /// No description provided for @addGame.
  ///
  /// In en, this message translates to:
  /// **'Add Game'**
  String get addGame;

  /// No description provided for @addEntry.
  ///
  /// In en, this message translates to:
  /// **'Add Entry'**
  String get addEntry;

  /// No description provided for @editEntry.
  ///
  /// In en, this message translates to:
  /// **'Edit Entry'**
  String get editEntry;

  /// No description provided for @userName.
  ///
  /// In en, this message translates to:
  /// **'User name'**
  String get userName;

  /// No description provided for @registeredMember.
  ///
  /// In en, this message translates to:
  /// **'Member'**
  String get registeredMember;

  /// No description provided for @cashbookCategory.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get cashbookCategory;

  /// No description provided for @selectRegisteredMember.
  ///
  /// In en, this message translates to:
  /// **'Select registered member'**
  String get selectRegisteredMember;

  /// No description provided for @selectCategory.
  ///
  /// In en, this message translates to:
  /// **'Select category'**
  String get selectCategory;

  /// No description provided for @noRegisteredMembersAvailable.
  ///
  /// In en, this message translates to:
  /// **'Add registered users in Admin first'**
  String get noRegisteredMembersAvailable;

  /// No description provided for @categoryDecoration.
  ///
  /// In en, this message translates to:
  /// **'Decoration'**
  String get categoryDecoration;

  /// No description provided for @categoryDonation.
  ///
  /// In en, this message translates to:
  /// **'Donation'**
  String get categoryDonation;

  /// No description provided for @categoryPooja.
  ///
  /// In en, this message translates to:
  /// **'Pooja'**
  String get categoryPooja;

  /// No description provided for @categoryGaneshIdol.
  ///
  /// In en, this message translates to:
  /// **'Ganesh Idol'**
  String get categoryGaneshIdol;

  /// No description provided for @categoryGaneshAagman.
  ///
  /// In en, this message translates to:
  /// **'Ganesh Aagman'**
  String get categoryGaneshAagman;

  /// No description provided for @categoryGaneshVisarjan.
  ///
  /// In en, this message translates to:
  /// **'Ganesh Visarjan'**
  String get categoryGaneshVisarjan;

  /// No description provided for @categoryPrasad.
  ///
  /// In en, this message translates to:
  /// **'Prasad'**
  String get categoryPrasad;

  /// No description provided for @categoryOthers.
  ///
  /// In en, this message translates to:
  /// **'Others'**
  String get categoryOthers;

  /// No description provided for @fieldRequired.
  ///
  /// In en, this message translates to:
  /// **'This field is required'**
  String get fieldRequired;

  /// No description provided for @invalidAmount.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid amount'**
  String get invalidAmount;

  /// No description provided for @invalidParticipants.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid participant count'**
  String get invalidParticipants;

  /// No description provided for @selectDate.
  ///
  /// In en, this message translates to:
  /// **'Select date'**
  String get selectDate;

  /// No description provided for @markAsCompleted.
  ///
  /// In en, this message translates to:
  /// **'Mark as completed'**
  String get markAsCompleted;

  /// No description provided for @noCashbookEntries.
  ///
  /// In en, this message translates to:
  /// **'No entries yet'**
  String get noCashbookEntries;

  /// No description provided for @addCashbookMessage.
  ///
  /// In en, this message translates to:
  /// **'Add received or paid entries to track cash flow.'**
  String get addCashbookMessage;

  /// No description provided for @tapStatusToToggle.
  ///
  /// In en, this message translates to:
  /// **'Tap status to change'**
  String get tapStatusToToggle;

  /// No description provided for @markedAsCompleted.
  ///
  /// In en, this message translates to:
  /// **'Marked as completed'**
  String get markedAsCompleted;

  /// No description provided for @markedAsReceived.
  ///
  /// In en, this message translates to:
  /// **'Marked as received'**
  String get markedAsReceived;

  /// No description provided for @markAsReceived.
  ///
  /// In en, this message translates to:
  /// **'Mark as received'**
  String get markAsReceived;

  /// No description provided for @markedAsPending.
  ///
  /// In en, this message translates to:
  /// **'Marked as pending'**
  String get markedAsPending;

  /// No description provided for @totalAmount.
  ///
  /// In en, this message translates to:
  /// **'Total amount'**
  String get totalAmount;

  /// No description provided for @totalPending.
  ///
  /// In en, this message translates to:
  /// **'Total Pending'**
  String get totalPending;

  /// No description provided for @totalReceived.
  ///
  /// In en, this message translates to:
  /// **'Total Received'**
  String get totalReceived;

  /// No description provided for @editPledge.
  ///
  /// In en, this message translates to:
  /// **'Edit Pledge'**
  String get editPledge;

  /// No description provided for @editMankari.
  ///
  /// In en, this message translates to:
  /// **'Edit Volunteer'**
  String get editMankari;

  /// No description provided for @editGame.
  ///
  /// In en, this message translates to:
  /// **'Edit Game'**
  String get editGame;

  /// No description provided for @status.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get status;

  /// No description provided for @updatedAt.
  ///
  /// In en, this message translates to:
  /// **'Updated at'**
  String get updatedAt;

  /// No description provided for @useCurrentTime.
  ///
  /// In en, this message translates to:
  /// **'Use current time'**
  String get useCurrentTime;

  /// No description provided for @tapToEdit.
  ///
  /// In en, this message translates to:
  /// **'Tap a pledge to edit'**
  String get tapToEdit;

  /// No description provided for @tapMankariToEdit.
  ///
  /// In en, this message translates to:
  /// **'Tap a volunteer to edit'**
  String get tapMankariToEdit;

  /// No description provided for @tapGameToEdit.
  ///
  /// In en, this message translates to:
  /// **'Tap a game to edit'**
  String get tapGameToEdit;

  /// No description provided for @noGamesYet.
  ///
  /// In en, this message translates to:
  /// **'No games yet'**
  String get noGamesYet;

  /// No description provided for @addGamesMessage.
  ///
  /// In en, this message translates to:
  /// **'Add games to track participants and winners.'**
  String get addGamesMessage;

  /// No description provided for @gameName.
  ///
  /// In en, this message translates to:
  /// **'Game name'**
  String get gameName;

  /// No description provided for @participants.
  ///
  /// In en, this message translates to:
  /// **'Participants'**
  String get participants;

  /// No description provided for @participantsCount.
  ///
  /// In en, this message translates to:
  /// **'{count} participants'**
  String participantsCount(int count);

  /// No description provided for @firstWinner.
  ///
  /// In en, this message translates to:
  /// **'1st Winner'**
  String get firstWinner;

  /// No description provided for @secondWinner.
  ///
  /// In en, this message translates to:
  /// **'2nd Winner'**
  String get secondWinner;

  /// No description provided for @thirdWinner.
  ///
  /// In en, this message translates to:
  /// **'3rd Winner'**
  String get thirdWinner;

  /// No description provided for @winnerOptionalHint.
  ///
  /// In en, this message translates to:
  /// **'Optional'**
  String get winnerOptionalHint;

  /// No description provided for @noVolunteersYet.
  ///
  /// In en, this message translates to:
  /// **'No volunteers yet'**
  String get noVolunteersYet;

  /// No description provided for @addVolunteersMessage.
  ///
  /// In en, this message translates to:
  /// **'Add mankari assignments to track volunteer shifts.'**
  String get addVolunteersMessage;

  /// No description provided for @role.
  ///
  /// In en, this message translates to:
  /// **'Role'**
  String get role;

  /// No description provided for @shift.
  ///
  /// In en, this message translates to:
  /// **'Shift'**
  String get shift;

  /// No description provided for @addPhoto.
  ///
  /// In en, this message translates to:
  /// **'Add Photo'**
  String get addPhoto;

  /// No description provided for @photoType.
  ///
  /// In en, this message translates to:
  /// **'Photo type'**
  String get photoType;

  /// No description provided for @photoYear.
  ///
  /// In en, this message translates to:
  /// **'Year'**
  String get photoYear;

  /// No description provided for @allPhotoTypes.
  ///
  /// In en, this message translates to:
  /// **'All types'**
  String get allPhotoTypes;

  /// No description provided for @allYears.
  ///
  /// In en, this message translates to:
  /// **'All years'**
  String get allYears;

  /// No description provided for @deletePhoto.
  ///
  /// In en, this message translates to:
  /// **'Delete photo'**
  String get deletePhoto;

  /// No description provided for @deletePhotoConfirm.
  ///
  /// In en, this message translates to:
  /// **'Delete this photo from the gallery?'**
  String get deletePhotoConfirm;

  /// No description provided for @photoDeleted.
  ///
  /// In en, this message translates to:
  /// **'Photo deleted'**
  String get photoDeleted;

  /// No description provided for @noPhotosYet.
  ///
  /// In en, this message translates to:
  /// **'No photos yet'**
  String get noPhotosYet;

  /// No description provided for @addPhotosMessage.
  ///
  /// In en, this message translates to:
  /// **'Upload photos and choose a type and year for your gallery.'**
  String get addPhotosMessage;

  /// No description provided for @uploadFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not upload photo'**
  String get uploadFailed;

  /// No description provided for @note.
  ///
  /// In en, this message translates to:
  /// **'Note'**
  String get note;

  /// No description provided for @noteHint.
  ///
  /// In en, this message translates to:
  /// **'Optional short note'**
  String get noteHint;

  /// No description provided for @splashTitle.
  ///
  /// In en, this message translates to:
  /// **'KRANTI GANESH SAIGAON'**
  String get splashTitle;

  /// No description provided for @splashTitleMarathi.
  ///
  /// In en, this message translates to:
  /// **'क्रांती गणेश सायगाव'**
  String get splashTitleMarathi;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @mobileNumber.
  ///
  /// In en, this message translates to:
  /// **'Mobile number'**
  String get mobileNumber;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @invalidMobile.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid 10-digit mobile number'**
  String get invalidMobile;

  /// No description provided for @invalidPassword.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid 4 digit password'**
  String get invalidPassword;

  /// No description provided for @invalidCredentials.
  ///
  /// In en, this message translates to:
  /// **'Invalid mobile number or password'**
  String get invalidCredentials;

  /// No description provided for @accountInactive.
  ///
  /// In en, this message translates to:
  /// **'This account is inactive. Contact an admin.'**
  String get accountInactive;

  /// No description provided for @loginFailed.
  ///
  /// In en, this message translates to:
  /// **'Login failed. Please try again.'**
  String get loginFailed;

  /// No description provided for @readOnlyMode.
  ///
  /// In en, this message translates to:
  /// **'Read-only access'**
  String get readOnlyMode;

  /// No description provided for @admin.
  ///
  /// In en, this message translates to:
  /// **'Admin'**
  String get admin;

  /// No description provided for @adminSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Manage users & roles'**
  String get adminSubtitle;

  /// No description provided for @addUser.
  ///
  /// In en, this message translates to:
  /// **'Add User'**
  String get addUser;

  /// No description provided for @editUser.
  ///
  /// In en, this message translates to:
  /// **'Edit User'**
  String get editUser;

  /// No description provided for @deleteUser.
  ///
  /// In en, this message translates to:
  /// **'Delete user'**
  String get deleteUser;

  /// No description provided for @deleteUserConfirm.
  ///
  /// In en, this message translates to:
  /// **'Delete this user?'**
  String get deleteUserConfirm;

  /// No description provided for @deletePledge.
  ///
  /// In en, this message translates to:
  /// **'Delete pledge'**
  String get deletePledge;

  /// No description provided for @deletePledgeConfirm.
  ///
  /// In en, this message translates to:
  /// **'Delete this pledge?'**
  String get deletePledgeConfirm;

  /// No description provided for @deleteEntry.
  ///
  /// In en, this message translates to:
  /// **'Delete entry'**
  String get deleteEntry;

  /// No description provided for @deleteEntryConfirm.
  ///
  /// In en, this message translates to:
  /// **'Delete this cashbook entry?'**
  String get deleteEntryConfirm;

  /// No description provided for @pledgeDeleted.
  ///
  /// In en, this message translates to:
  /// **'Pledge deleted'**
  String get pledgeDeleted;

  /// No description provided for @entryDeleted.
  ///
  /// In en, this message translates to:
  /// **'Entry deleted'**
  String get entryDeleted;

  /// No description provided for @noUsersYet.
  ///
  /// In en, this message translates to:
  /// **'No users yet'**
  String get noUsersYet;

  /// No description provided for @addUsersMessage.
  ///
  /// In en, this message translates to:
  /// **'Add users with name, mobile number, and role.'**
  String get addUsersMessage;

  /// No description provided for @userRole.
  ///
  /// In en, this message translates to:
  /// **'Role'**
  String get userRole;

  /// No description provided for @roleAdmin.
  ///
  /// In en, this message translates to:
  /// **'Admin'**
  String get roleAdmin;

  /// No description provided for @roleSuperAdmin.
  ///
  /// In en, this message translates to:
  /// **'Super Admin'**
  String get roleSuperAdmin;

  /// No description provided for @roleMember.
  ///
  /// In en, this message translates to:
  /// **'Member'**
  String get roleMember;

  /// No description provided for @roleUser.
  ///
  /// In en, this message translates to:
  /// **'User'**
  String get roleUser;

  /// No description provided for @userStatus.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get userStatus;

  /// No description provided for @userActive.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get userActive;

  /// No description provided for @userInactive.
  ///
  /// In en, this message translates to:
  /// **'Inactive'**
  String get userInactive;

  /// No description provided for @mobileAlreadyExists.
  ///
  /// In en, this message translates to:
  /// **'This mobile number is already registered'**
  String get mobileAlreadyExists;

  /// No description provided for @cannotDeleteSelf.
  ///
  /// In en, this message translates to:
  /// **'You cannot delete your own account'**
  String get cannotDeleteSelf;

  /// No description provided for @cannotDeleteSuperAdmin.
  ///
  /// In en, this message translates to:
  /// **'Super Admin cannot be deleted'**
  String get cannotDeleteSuperAdmin;

  /// No description provided for @sendRegistrationWhatsApp.
  ///
  /// In en, this message translates to:
  /// **'Send registration on WhatsApp?'**
  String get sendRegistrationWhatsApp;

  /// No description provided for @sendRegistrationWhatsAppMessage.
  ///
  /// In en, this message translates to:
  /// **'Open WhatsApp with a ready message for {name}? You will need to tap Send.'**
  String sendRegistrationWhatsAppMessage(String name);

  /// No description provided for @sendViaWhatsApp.
  ///
  /// In en, this message translates to:
  /// **'Send on WhatsApp'**
  String get sendViaWhatsApp;

  /// No description provided for @skipForNow.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skipForNow;

  /// No description provided for @whatsAppNotAvailable.
  ///
  /// In en, this message translates to:
  /// **'Could not open WhatsApp on this device'**
  String get whatsAppNotAvailable;

  /// No description provided for @registrationWhatsAppBody.
  ///
  /// In en, this message translates to:
  /// **'Hello {name},\n\nYou are registered on {appName} app.\n\nLogin details:\nMobile: {mobile}\nPassword: {password}\n\n— {appName}'**
  String registrationWhatsAppBody(
    String name,
    String appName,
    String mobile,
    String password,
  );
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'mr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'mr':
      return AppLocalizationsMr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
