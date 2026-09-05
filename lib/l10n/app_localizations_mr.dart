// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Marathi (`mr`).
class AppLocalizationsMr extends AppLocalizations {
  AppLocalizationsMr([String locale = 'mr']) : super(locale);

  @override
  String get appName => 'क्रांती गणेश मंडळ';

  @override
  String get appSubtitle => 'सायगाओन';

  @override
  String get pledgeLedger => 'निधी नोंदवही';

  @override
  String get pledgeLedgerSubtitle => 'प्रतिज्ञा व संकलनाची नोंद';

  @override
  String get cashbook => 'रोखपत्र';

  @override
  String get cashbookSubtitle => 'प्राप्त आणि दिले';

  @override
  String get games => 'खेळ';

  @override
  String get gamesSubtitle => 'सण स्पर्धा';

  @override
  String get mankari => 'मानकरी';

  @override
  String get mankariSubtitle => 'स्वयंसेवक नियुक्ती';

  @override
  String get gallery => 'गॅलरी';

  @override
  String get gallerySubtitle => 'छायाचित्र व आठवणी';

  @override
  String get reports => 'अहवाल';

  @override
  String get reportsSubtitle => 'सारांश व निर्यात';

  @override
  String get noPledgesYet => 'अद्याप कोणतीही प्रतिज्ञा नाही';

  @override
  String get addPledgesMessage =>
      'प्रतिज्ञा व संकलनाची नोंद ठेवण्यासाठी प्रतिज्ञा जोडा.';

  @override
  String get completed => 'पूर्ण';

  @override
  String get received => 'प्राप्त';

  @override
  String get pending => 'प्रलंबित';

  @override
  String get allStatuses => 'सर्व';

  @override
  String get income => 'प्राप्त';

  @override
  String get expense => 'दिले';

  @override
  String teamsRegistered(int count) {
    return '$count संघ नोंदणीकृत';
  }

  @override
  String photosCount(int count) {
    return '$count छायाचित्रे';
  }

  @override
  String get pledgeSummary => 'प्रतिज्ञा सारांश';

  @override
  String get pledgeSummaryDesc => 'एकूण गोळा केलेली व प्रलंबित प्रतिज्ञा';

  @override
  String pledgeSummaryDetail(String collected, String pending) {
    return '$collected गोळा केले · $pending प्रलंबित';
  }

  @override
  String get cashbookBalance => 'रोखपत्र शिल्लक';

  @override
  String get cashbookBalanceDesc => 'दिलेल्या रकमेनंतरची शिल्लक';

  @override
  String cashbookBalanceDetail(String income, String expense) {
    return '$income प्राप्त · $expense दिले';
  }

  @override
  String get volunteerHours => 'स्वयंसेवक तास';

  @override
  String get volunteerHoursDesc => 'एकूण मानकरी पाळी नोंद';

  @override
  String get scheduled => 'नियोजित';

  @override
  String get inProgress => 'सुरू';

  @override
  String get language => 'भाषा';

  @override
  String get english => 'English';

  @override
  String get marathi => 'मराठी';

  @override
  String get gameTugOfWar => 'रस्साकाठी';

  @override
  String get gameMatkiPhod => 'मटकी फोड';

  @override
  String get gameRangoli => 'रांगोळी स्पर्धा';

  @override
  String get shiftMorning => 'सकाळ';

  @override
  String get shiftEvening => 'संध्याकाळ';

  @override
  String get shiftNight => 'रात्र';

  @override
  String get shiftAllDay => 'संपूर्ण दिवस';

  @override
  String get roleDecorationLead => 'सजावट प्रमुख';

  @override
  String get roleFoodCommittee => 'जेवण समिती';

  @override
  String get roleSecurity => 'सुरक्षा';

  @override
  String get roleCulturalEvents => 'सांस्कृतिक कार्यक्रम';

  @override
  String get entryDonationPatil => 'दान — पाटील कुटुंब';

  @override
  String get entryFlowerDecoration => 'फुलांची सजावट';

  @override
  String get entryPledgeCollection => 'प्रतिज्ञा संकलन';

  @override
  String get entrySoundSystem => 'ध्वनिक्षेपक भाडे';

  @override
  String get albumVisarjan2025 => 'विसर्जन';

  @override
  String get albumAartiCeremony => 'आरती समारंभ';

  @override
  String get albumCulturalNight => 'सांस्कृतिक संध्याकाळ';

  @override
  String get albumPranPratishtha => 'प्राणप्रतिष्ठा';

  @override
  String get add => 'जोडा';

  @override
  String get save => 'जतन करा';

  @override
  String get cancel => 'रद्द करा';

  @override
  String get name => 'नाव';

  @override
  String get amount => 'रक्कम';

  @override
  String get date => 'तारीख';

  @override
  String get description => 'वर्णन';

  @override
  String get addPledge => 'प्रतिज्ञा जोडा';

  @override
  String get addMankari => 'स्वयंसेवक जोडा';

  @override
  String get addGame => 'खेळ जोडा';

  @override
  String get addEntry => 'नोंद जोडा';

  @override
  String get editEntry => 'नोंद संपादित करा';

  @override
  String get userName => 'वापरकर्त्याचे नाव';

  @override
  String get registeredMember => 'सदस्य';

  @override
  String get cashbookCategory => 'श्रेणी';

  @override
  String get selectRegisteredMember => 'नोंदणीकृत सदस्य निवडा';

  @override
  String get selectCategory => 'श्रेणी निवडा';

  @override
  String get noRegisteredMembersAvailable =>
      'प्रशासनात नोंदणीकृत वापरकर्ते जोडा';

  @override
  String get categoryDecoration => 'सजावट';

  @override
  String get categoryDonation => 'देणगी';

  @override
  String get categoryPooja => 'पूजा';

  @override
  String get categoryGaneshIdol => 'गणेश मूर्ती';

  @override
  String get categoryGaneshAagman => 'गणेश आगमन';

  @override
  String get categoryGaneshVisarjan => 'गणेश विसर्जन';

  @override
  String get categoryPrasad => 'प्रसाद';

  @override
  String get categoryOthers => 'इतर';

  @override
  String get fieldRequired => 'हे फील्ड आवश्यक आहे';

  @override
  String get invalidAmount => 'वैध रक्कम प्रविष्ट करा';

  @override
  String get invalidParticipants => 'वैध सहभागी संख्या प्रविष्ट करा';

  @override
  String get selectDate => 'तारीख निवडा';

  @override
  String get markAsCompleted => 'पूर्ण म्हणून चिन्हांकित करा';

  @override
  String get noCashbookEntries => 'अद्याप कोणतीही नोंद नाही';

  @override
  String get addCashbookMessage =>
      'रोख प्रवाहाची नोंद ठेवण्यासाठी प्राप्त किंवा दिलेली रक्कम जोडा.';

  @override
  String get tapStatusToToggle => 'स्थिती बदलण्यासाठी टॅप करा';

  @override
  String get markedAsCompleted => 'पूर्ण म्हणून चिन्हांकित';

  @override
  String get markedAsReceived => 'प्राप्त म्हणून चिन्हांकित';

  @override
  String get markAsReceived => 'प्राप्त म्हणून चिन्हांकित करा';

  @override
  String get markedAsPending => 'प्रलंबित म्हणून चिन्हांकित';

  @override
  String get totalAmount => 'एकूण रक्कम';

  @override
  String get totalPending => 'एकूण प्रलंबित';

  @override
  String get totalReceived => 'एकूण प्राप्त';

  @override
  String get editPledge => 'प्रतिज्ञा संपादित करा';

  @override
  String get editMankari => 'स्वयंसेवक संपादित करा';

  @override
  String get editGame => 'खेळ संपादित करा';

  @override
  String get status => 'स्थिती';

  @override
  String get updatedAt => 'अद्यतन वेळ';

  @override
  String get useCurrentTime => 'सध्याची वेळ वापरा';

  @override
  String get tapToEdit => 'संपादित करण्यासाठी प्रतिज्ञेवर टॅप करा';

  @override
  String get tapMankariToEdit => 'संपादित करण्यासाठी स्वयंसेवकावर टॅप करा';

  @override
  String get tapGameToEdit => 'संपादित करण्यासाठी खेळावर टॅप करा';

  @override
  String get noGamesYet => 'अद्याप कोणतेही खेळ नाहीत';

  @override
  String get addGamesMessage => 'सहभागी आणि विजेते नोंदण्यासाठी खेळ जोडा.';

  @override
  String get gameName => 'खेळाचे नाव';

  @override
  String get participants => 'सहभागी';

  @override
  String participantsCount(int count) {
    return '$count सहभागी';
  }

  @override
  String get firstWinner => 'पहिला विजेता';

  @override
  String get secondWinner => 'दुसरा विजेता';

  @override
  String get thirdWinner => 'तिसरा विजेता';

  @override
  String get winnerOptionalHint => 'ऐच्छिक';

  @override
  String get noVolunteersYet => 'अद्याप कोणतेही स्वयंसेवक नाहीत';

  @override
  String get addVolunteersMessage =>
      'स्वयंसेवक पाळीची नोंद ठेवण्यासाठी मानकरी नियुक्ती जोडा.';

  @override
  String get role => 'भूमिका';

  @override
  String get shift => 'पाळी';

  @override
  String get addPhoto => 'छायाचित्र जोडा';

  @override
  String get photoType => 'छायाचित्र प्रकार';

  @override
  String get photoYear => 'वर्ष';

  @override
  String get allPhotoTypes => 'सर्व प्रकार';

  @override
  String get allYears => 'सर्व वर्षे';

  @override
  String get deletePhoto => 'छायाचित्र हटवा';

  @override
  String get deletePhotoConfirm => 'गॅलरीमधून हे छायाचित्र हटवायचे?';

  @override
  String get photoDeleted => 'छायाचित्र हटवले';

  @override
  String get noPhotosYet => 'अद्याप कोणतेही छायाचित्र नाही';

  @override
  String get addPhotosMessage =>
      'छायाचित्रे अपलोड करा आणि प्रकार व वर्ष निवडा.';

  @override
  String get uploadFailed => 'छायाचित्र अपलोड करता आले नाही';

  @override
  String get note => 'टीप';

  @override
  String get noteHint => 'ऐच्छिक छोटी टीप';

  @override
  String get splashTitle => 'KRANTI GANESH SAIGAON';

  @override
  String get splashTitleMarathi => 'क्रांती गणेश सायगाव';

  @override
  String get login => 'लॉगिन';

  @override
  String get logout => 'लॉगआउट';

  @override
  String get mobileNumber => 'मोबाईल नंबर';

  @override
  String get password => 'पासवर्ड';

  @override
  String get invalidMobile => 'वैध १० अंकी मोबाईल नंबर प्रविष्ट करा';

  @override
  String get invalidPassword => 'वैध ४ अंकी पासवर्ड प्रविष्ट करा';

  @override
  String get invalidCredentials => 'चुकीचा मोबाईल नंबर किंवा पासवर्ड';

  @override
  String get accountInactive =>
      'हे खाते निष्क्रिय आहे. प्रशासकाशी संपर्क साधा.';

  @override
  String get loginFailed => 'लॉगिन अयशस्वी. पुन्हा प्रयत्न करा.';

  @override
  String get readOnlyMode => 'फक्त वाचन प्रवेश';

  @override
  String get admin => 'प्रशासन';

  @override
  String get adminSubtitle => 'वापरकर्ते आणि भूमिका व्यवस्थापित करा';

  @override
  String get addUser => 'वापरकर्ता जोडा';

  @override
  String get editUser => 'वापरकर्ता संपादित करा';

  @override
  String get deleteUser => 'वापरकर्ता हटवा';

  @override
  String get deleteUserConfirm => 'हा वापरकर्ता हटवायचा?';

  @override
  String get deletePledge => 'प्रतिज्ञा हटवा';

  @override
  String get deletePledgeConfirm => 'ही प्रतिज्ञा हटवायची?';

  @override
  String get deleteEntry => 'नोंद हटवा';

  @override
  String get deleteEntryConfirm => 'ही रोखपत्र नोंद हटवायची?';

  @override
  String get pledgeDeleted => 'प्रतिज्ञा हटवली';

  @override
  String get entryDeleted => 'नोंद हटवली';

  @override
  String get noUsersYet => 'अद्याप कोणतेही वापरकर्ते नाहीत';

  @override
  String get addUsersMessage => 'नाव, मोबाईल नंबर आणि भूमिकेसह वापरकर्ते जोडा.';

  @override
  String get userRole => 'भूमिका';

  @override
  String get roleAdmin => 'प्रशासक';

  @override
  String get roleSuperAdmin => 'सुपर प्रशासक';

  @override
  String get roleMember => 'सदस्य';

  @override
  String get roleUser => 'वापरकर्ता';

  @override
  String get userStatus => 'स्थिती';

  @override
  String get userActive => 'सक्रिय';

  @override
  String get userInactive => 'निष्क्रिय';

  @override
  String get mobileAlreadyExists => 'हा मोबाईल नंबर आधीच नोंदणीकृत आहे';

  @override
  String get cannotDeleteSelf => 'तुम्ही स्वतःचे खाते हटवू शकत नाही';

  @override
  String get cannotDeleteSuperAdmin => 'सुपर प्रशासक हटवता येत नाही';

  @override
  String get sendRegistrationWhatsApp => 'WhatsApp वर नोंदणी पाठवायची?';

  @override
  String sendRegistrationWhatsAppMessage(String name) {
    return '$name साठी WhatsApp संदेश तयार करायचा? पाठवण्यासाठी तुम्हाला Send दाबावे लागेल.';
  }

  @override
  String get sendViaWhatsApp => 'WhatsApp वर पाठवा';

  @override
  String get skipForNow => 'वगळा';

  @override
  String get whatsAppNotAvailable => 'या डिव्हाइसवर WhatsApp उघडता आले नाही';

  @override
  String registrationWhatsAppBody(
    String name,
    String appName,
    String mobile,
    String password,
  ) {
    return 'नमस्कार $name,\n\nतुम्ही $appName अॅपवर नोंदणीकृत आहात.\n\nलॉगिन तपशील:\nमोबाईल: $mobile\nपासवर्ड: $password\n\n— $appName';
  }
}
