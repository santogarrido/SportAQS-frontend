import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:sportaqs/models/facility.dart';
import 'package:sportaqs/providers/facility_provider.dart';
import 'package:sportaqs/widgets/admin/admin_facility_card.dart';

class AdminFacilitiesScreen extends StatefulWidget {
  const AdminFacilitiesScreen({super.key});

  @override
  State<AdminFacilitiesScreen> createState() => _AdminFacilitiesScreenState();
}

class _AdminFacilitiesScreenState extends State<AdminFacilitiesScreen> {
  @override
  void initState() {
    super.initState();
    // Cargar facilities al iniciar
    final facilityProvider = context.read<FacilityProvider>();
    facilityProvider.getFacilities();
  }

  @override
  Widget build(BuildContext context) {
    final parentContext = context;
    final facilityProvider = context.watch<FacilityProvider>();
    List<Facility> facilities = facilityProvider.facilities;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Lista de Facilities"),
        backgroundColor: Colors.purple,
      ),
      body: facilityProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.separated(
              itemCount: facilities.length,
              separatorBuilder: (_, __) => const Divider(),
              itemBuilder: (context, index) {
                final facility = facilities[index];
                final messenger = ScaffoldMessenger.of(context);

                return Slidable(
                  key: ValueKey(facility.id),

                  // 👉 Swipe izquierdo: activar/desactivar + editar
                  startActionPane: ActionPane(
                    motion: const ScrollMotion(),
                    children: [
                      // Activar / Desactivar
                      SlidableAction(
                        onPressed: (_) async {
                          // Cerrar Slidable antes de async
                          Slidable.of(context)?.close();

                          if (facility.activated) {
                            await facilityProvider.deactivateFacility(facility.id);
                          } else {
                            await facilityProvider.activateFacility(facility.id);
                          }

                          if (!mounted) return;

                          // Actualizamos el estado local para reflejar el cambio
                          setState(() {
                            facility.activated = !facility.activated;
                          });

                          messenger.showSnackBar(
                            SnackBar(
                              content: Text(facility.activated
                                  ? "Facility activada"
                                  : "Facility desactivada"),
                              backgroundColor: Colors.green,
                              duration: const Duration(seconds: 2),
                            ),
                          );
                        },
                        backgroundColor: facility.activated ? Colors.red : Colors.green,
                        foregroundColor: Colors.white,
                        icon: facility.activated ? Icons.toggle_off : Icons.toggle_on,
                        label: facility.activated ? "Desactivar" : "Activar",
                      ),

                      // Editar
                      SlidableAction(
                        onPressed: (_) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => AdminFacilityCard(facility: facility),
                            ),
                          );
                        },
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        icon: Icons.edit,
                        label: "Editar",
                      ),
                    ],
                  ),

                  // 👉 Swipe derecho: eliminar
                  endActionPane: ActionPane(
                    motion: const ScrollMotion(),
                    children: [
                      SlidableAction(
                        onPressed: (_) async {
                          final confirm = await showDialog<bool>(
                            context: context,
                            builder: (_) => AlertDialog(
                              title: const Text("Eliminar facility"),
                              content: const Text(
                                  "¿Seguro que deseas eliminar esta facility?"),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context, false),
                                  child: const Text("Cancelar"),
                                ),
                                TextButton(
                                  onPressed: () => Navigator.pop(context, true),
                                  child: const Text(
                                    "Eliminar",
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ),
                              ],
                            ),
                          );

                          if (confirm == true) {
                            Slidable.of(context)?.close();
                            await facilityProvider.deleteFacility(facility.id);

                            if (!mounted) return;
                            messenger.showSnackBar(
                              const SnackBar(
                                content:
                                    Text("Facility eliminada correctamente"),
                                backgroundColor: Colors.green,
                                duration: Duration(seconds: 2),
                              ),
                            );
                          }
                        },
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        icon: Icons.delete,
                        label: "Eliminar",
                      ),
                    ],
                  ),

                  // Contenido de la tarjeta
                  child: FacilityCard(facility: facility),
                );
              },
            ),
    );
  }
}

/// Widget solo para mostrar info de la facility
class FacilityCard extends StatelessWidget {
  final Facility facility;

  const FacilityCard({super.key, required this.facility});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: facility.activated ? Colors.lightBlueAccent : Colors.grey,
          width: 1.5,
        ),
      ),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Nombre + estado
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  facility.name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  facility.activated ? "Activa" : "Inactiva",
                  style: TextStyle(
                    color: facility.activated ? Colors.green : Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            // Ubicación
            Row(
              children: [
                const Icon(Icons.location_on, size: 18),
                const SizedBox(width: 6),
                Expanded(child: Text(facility.location)),
              ],
            ),
            const SizedBox(height: 6),
            // Horario
            Row(
              children: [
                const Icon(Icons.schedule, size: 18),
                const SizedBox(width: 6),
                Text('${facility.openTime} - ${facility.closeTime}'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
