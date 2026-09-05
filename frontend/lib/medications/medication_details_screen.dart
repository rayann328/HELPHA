import 'package:flutter/material.dart';
import '../core/localization/app_strings.dart'; 

import '../core/constants/app_colors.dart'; 
import '../models/medication.dart'; 
import '../services/medication_service.dart'; 
import '../services/reminder_service.dart'; 

class MedicationDetailsScreen extends StatefulWidget { 
final Medication medication; 

const MedicationDetailsScreen({ 
super.key, 
required this.medication, 
}); 

@override 
State<MedicationDetailsScreen> createState() => 
_MedicationDetailsScreenState(); 
} 

class _MedicationDetailsScreenState 
extends State<MedicationDetailsScreen> { 
final MedicationService _medicationService = 
MedicationService(); 

final ReminderService _reminderService = 
ReminderService(); 

bool _loading = false; 

Future<void> _delete() async { 
final confirmed = 
await showDialog<bool>( 
context: context, 
builder: (context) { 
return AlertDialog( 
title: 
Text(AppStrings.get(context, 'deleteMedicationQuestion')), 
content: Text(AppStrings.get(context, 'deleteMedicationDescription'), 
), 
actions: [ 
TextButton( 
onPressed: () => 
Navigator.pop(context, false), 
child: Text(AppStrings.get(context, 'cancel')), 
), 
ElevatedButton( 
onPressed: () => 
Navigator.pop(context, true), 
child: Text(AppStrings.get(context, 'delete')), 
), 
], 
); 
}, 
); 

if (confirmed != true) { 
return; 
} 

setState(() { 
_loading = true; 
}); 

try { 
await _medicationService.deleteMedication( 
widget.medication.id, 
); 

if (!mounted) return; 

ScaffoldMessenger.of(context).showSnackBar( 
SnackBar( 
content: 
Text(AppStrings.get(context, 'medicationDeleted')), 
), 
); 

Navigator.pop(context); 
} catch (e) { 
if (!mounted) return; 

setState(() { 
_loading = false; 
}); 

ScaffoldMessenger.of(context).showSnackBar( 
SnackBar( 
content: Text(e.toString()), 
), 
); 
} 
} 

Future<void> _archive() async { 
setState(() { 
_loading = true; 
}); 

try { 
await _medicationService.archiveMedication( 
widget.medication.id, 
); 

if (!mounted) return; 

Navigator.pop(context); 
} catch (e) { 
if (!mounted) return; 

setState(() { 
_loading = false; 
}); 

ScaffoldMessenger.of(context).showSnackBar( 
SnackBar( 
content: Text(e.toString()), 
), 
); 
} 
} 

Future<void> _markTaken() async { 
setState(() { 
_loading = true; 
}); 

try { 
final reminders = 
await _reminderService.getToday(); 

final medicationReminders = 
reminders.where((reminder) { 
final medication = 
reminder['medication']; 

if (medication is! Map) { 
return false; 
} 

return medication['id']?.toString() == 
widget.medication.id; 
}).toList(); 

if (medicationReminders.isEmpty) { 
if (!mounted) return; 

setState(() { 
_loading = false; 
}); 

ScaffoldMessenger.of(context).showSnackBar( 
SnackBar( 
content: Text(AppStrings.get(context, 'noReminderToday'), 
), 
), 
); 

return; 
} 

await _reminderService.updateStatus( 
medicationReminders.first['id'].toString(), 
'TAKEN', 
); 

if (!mounted) return; 

setState(() { 
_loading = false; 
}); 

ScaffoldMessenger.of(context).showSnackBar( 
SnackBar( 
content: Text(AppStrings.get(context, 'medicationMarkedTaken'), 
), 
), 
); 
} catch (e) { 
if (!mounted) return; 

setState(() { 
_loading = false; 
}); 

ScaffoldMessenger.of(context).showSnackBar( 
SnackBar( 
content: Text(e.toString()), 
), 
); 
} 
} 

Widget _infoRow( 
String title, 
String value, 
IconData icon, 
) { 
if (value.trim().isEmpty) { 
return SizedBox.shrink(); 
} 

return Card( 
child: ListTile( 
leading: Icon( 
icon, 
color: AppColors.primary, 
), 
title: Text( 
title, 
style: TextStyle( 
fontWeight: FontWeight.bold, 
), 
), 
subtitle: Text(value), 
), 
); 
} 

@override 
Widget build(BuildContext context) { 
final medication = widget.medication; 

return Scaffold( 
appBar: AppBar( 
title: Text(medication.name), 
actions: [ 
PopupMenuButton<String>( 
onSelected: (value) { 
if (value == 'archive') { 
_archive(); 
} else if (value == 'delete') { 
_delete(); 
} 
}, 
itemBuilder: (context) => [ 
PopupMenuItem( 
value: 'archive', 
child: Text(AppStrings.get(context, 'archive')), 
), 
PopupMenuItem( 
value: 'delete', 
child: Text(AppStrings.get(context, 'delete')), 
), 
], 
), 
], 
), 
body: ListView( 
padding: EdgeInsets.all(20), 
children: [ 
CircleAvatar( 
radius: 42, 
backgroundColor: 
AppColors.primary.withValues( 
alpha: 0.12, 
), 
child: Icon( 
Icons.medication, 
size: 44, 
color: AppColors.primary, 
), 
), 
SizedBox(height: 16), 

Center( 
child: Text( 
medication.name, 
style: TextStyle( 
fontSize: 24, 
fontWeight: FontWeight.bold, 
), 
), 
), 

SizedBox(height: 24), 

_infoRow( 
'Dosage', 
medication.dosage ?? '', 
Icons.medication, 
), 

_infoRow( 
'Type', 
medication.type ?? '', 
Icons.category, 
), 

_infoRow( 
'Strength', 
medication.strength ?? '', 
Icons.science, 
), 

_infoRow( 
'Generic name', 
medication.genericName ?? '', 
Icons.info_outline, 
), 

_infoRow( 
'Brand name', 
medication.brandName ?? '', 
Icons.business, 
), 

_infoRow( 
'Notes', 
medication.notes ?? '', 
Icons.notes, 
), 

SizedBox(height: 24), 

SizedBox( 
height: 52, 
child: ElevatedButton.icon( 
onPressed: 
_loading ? null : _markTaken, 
icon: Icon( 
Icons.check_circle, 
), 
label: Text(AppStrings.get(context, 'markTodayTaken'), 
), 
), 
), 

SizedBox(height: 12), 

OutlinedButton( 
onPressed: 
_loading ? null : _delete, 
child: Text( 
'Delete Medication', 
), 
), 
], 
), 
); 
} 
}