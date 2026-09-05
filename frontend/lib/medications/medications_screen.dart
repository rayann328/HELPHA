import 'package:flutter/material.dart';
import '../core/localization/app_strings.dart'; 

import '../core/constants/app_colors.dart'; 
import '../models/medication.dart'; 
import '../services/medication_service.dart'; 
import 'add_medication_screen.dart'; 
import 'medication_details_screen.dart'; 

class MedicationsScreen extends StatefulWidget { 
const MedicationsScreen({super.key}); 

@override 
State<MedicationsScreen> createState() => 
_MedicationsScreenState(); 
} 

class _MedicationsScreenState 
extends State<MedicationsScreen> { 
final MedicationService _service = MedicationService(); 

List<Medication> _medications = []; 
bool _loading = true; 
String? _error; 

@override 
void initState() { 
super.initState(); 
_loadMedications(); 
} 

Future<void> _loadMedications() async { 
setState(() { 
_loading = true; 
_error = null; 
}); 

try { 
final medications = 
await _service.getMedications(); 

if (!mounted) return; 

setState(() { 
_medications = medications 
.where( 
(medication) => 
medication.status != 'ARCHIVED', 
) 
.toList(); 
_loading = false; 
}); 
} catch (e) { 
if (!mounted) return; 

setState(() { 
_error = e.toString(); 
_loading = false; 
}); 
} 
} 

Future<void> _openAddMedication() async { 
final created = 
await Navigator.push<Medication>( 
context, 
MaterialPageRoute( 
builder: (_) => 
AddMedicationScreen(), 
), 
); 

if (created != null) { 
await _loadMedications(); 
} 
} 

Future<void> _openDetails( 
Medication medication, 
) async { 
await Navigator.push( 
context, 
MaterialPageRoute( 
builder: (_) => 
MedicationDetailsScreen( 
medication: medication, 
), 
), 
); 

await _loadMedications(); 
} 

@override 
Widget build(BuildContext context) { 
return Scaffold( 
appBar: AppBar( 
title: Text(AppStrings.get(context, 'medications')), 
actions: [ 
IconButton( 
onPressed: _loadMedications, 
icon: Icon(Icons.refresh), 
), 
], 
), 
floatingActionButton: FloatingActionButton( 
onPressed: _openAddMedication, 
child: Icon(Icons.add), 
), 
body: _buildBody(), 
); 
} 

Widget _buildBody() { 
if (_loading) { 
return Center( 
child: CircularProgressIndicator(), 
); 
} 

if (_error != null) { 
return Center( 
child: Padding( 
padding: EdgeInsets.all(24), 
child: Column( 
mainAxisSize: MainAxisSize.min, 
children: [ 
Icon( 
Icons.error_outline, 
size: 48, 
), 
SizedBox(height: 12), 
Text( 
_error!, 
textAlign: TextAlign.center, 
), 
SizedBox(height: 16), 
ElevatedButton( 
onPressed: _loadMedications, 
child: Text(AppStrings.get(context, 'retry')), 
), 
], 
), 
), 
); 
} 

if (_medications.isEmpty) { 
return RefreshIndicator( 
onRefresh: _loadMedications, 
child: ListView( 
children: [ 
SizedBox(height: 180), 
Icon( 
Icons.medication_outlined, 
size: 70, 
color: AppColors.primary, 
), 
SizedBox(height: 16), 
Center( 
child: Text(AppStrings.get(context, 'noMedications'), 
style: TextStyle( 
fontSize: 20, 
fontWeight: FontWeight.bold, 
), 
), 
), 
SizedBox(height: 8), 
Center( 
child: Text(AppStrings.get(context, 'addFirstMedication'), 
), 
), 
], 
), 
); 
} 

return RefreshIndicator( 
onRefresh: _loadMedications, 
child: ListView.builder( 
padding: EdgeInsets.all(16), 
itemCount: _medications.length, 
itemBuilder: (context, index) { 
final medication = 
_medications[index]; 

return Card( 
margin: EdgeInsets.only( 
bottom: 12, 
), 
child: ListTile( 
contentPadding: 
EdgeInsets.symmetric( 
horizontal: 16, 
vertical: 8, 
), 
leading: CircleAvatar( 
backgroundColor: 
AppColors.primary.withValues( 
alpha: 0.12, 
), 
child: Icon( 
Icons.medication, 
color: AppColors.primary, 
), 
), 
title: Text( 
medication.name, 
style: TextStyle( 
fontWeight: FontWeight.bold, 
), 
), 
subtitle: Text( 
[ 
if (medication.dosage != null && 
medication.dosage!.isNotEmpty) 
medication.dosage!, 
if (medication.type != null && 
medication.type!.isNotEmpty) 
medication.type!, 
].join(' • '), 
), 
trailing: Icon( 
Icons.chevron_right, 
), 
onTap: () => 
_openDetails(medication), 
), 
); 
}, 
), 
); 
} 
}