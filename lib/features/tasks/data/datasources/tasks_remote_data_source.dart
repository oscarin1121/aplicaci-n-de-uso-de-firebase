import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_practice/core/utils/app_exception.dart';
import 'package:firebase_practice/core/utils/firebase_error_mapper.dart';
import 'package:firebase_practice/features/tasks/data/models/task_model.dart';
import 'package:firebase_practice/features/tasks/domain/entities/task.dart';

class TasksRemoteDataSource {
  TasksRemoteDataSource(this._firestore);

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> _collection(String userId) {
    return _firestore.collection('users').doc(userId).collection('tasks');
  }

  Stream<List<TaskModel>> watchTasks(String userId) {
    try {
      return _collection(userId)
          .orderBy('updatedAt', descending: true)
          .snapshots()
          .map((QuerySnapshot<Map<String, dynamic>> snapshot) {
            return snapshot.docs
                .map(TaskModel.fromDocument)
                .toList(growable: false);
          });
    } on FirebaseException catch (exception) {
      throw mapFirebaseException(exception);
    } catch (_) {
      throw const AppException('No se pudo escuchar la colección de tareas.');
    }
  }

  Stream<TaskModel> watchTask({
    required String userId,
    required String taskId,
  }) {
    try {
      return _collection(userId).doc(taskId).snapshots().map((
        DocumentSnapshot<Map<String, dynamic>> document,
      ) {
        if (!document.exists || document.data() == null) {
          throw const AppException('La tarea ya no existe en Firestore.');
        }

        return TaskModel.fromDocument(document);
      });
    } on FirebaseException catch (exception) {
      throw mapFirebaseException(exception);
    } catch (_) {
      throw const AppException('No se pudo escuchar la tarea solicitada.');
    }
  }

  Future<String> saveTask({required String userId, required Task task}) async {
    try {
      final CollectionReference<Map<String, dynamic>> collection = _collection(
        userId,
      );
      final DocumentReference<Map<String, dynamic>> document = task.id.isEmpty
          ? collection.doc()
          : collection.doc(task.id);
      final DateTime now = DateTime.now();
      final String referenceCode = task.referenceCode.isEmpty
          ? _buildReferenceCode(document.id)
          : task.referenceCode;

      final TaskModel model = TaskModel.fromTask(
        task.copyWith(
          id: document.id,
          ownerId: userId,
          referenceCode: referenceCode,
          createdAt: task.id.isEmpty ? now : task.createdAt,
          updatedAt: now,
        ),
      );

      await document.set(model.toDocument(), SetOptions(merge: true));

      return document.id;
    } on FirebaseException catch (exception) {
      throw mapFirebaseException(exception);
    } catch (_) {
      throw const AppException('No se pudo guardar la tarea.');
    }
  }

  Future<void> deleteTask({
    required String userId,
    required String taskId,
  }) async {
    try {
      await _collection(userId).doc(taskId).delete();
    } on FirebaseException catch (exception) {
      throw mapFirebaseException(exception);
    } catch (_) {
      throw const AppException('No se pudo eliminar la tarea.');
    }
  }

  Future<void> setTaskCompletion({
    required String userId,
    required String taskId,
    required bool isCompleted,
  }) async {
    try {
      final DateTime now = DateTime.now();

      await _collection(userId).doc(taskId).update(<String, dynamic>{
        'isCompleted': isCompleted,
        'updatedAt': Timestamp.fromDate(now),
        'completedAt': isCompleted ? Timestamp.fromDate(now) : null,
      });
    } on FirebaseException catch (exception) {
      throw mapFirebaseException(exception);
    } catch (_) {
      throw const AppException('No se pudo actualizar el estado de la tarea.');
    }
  }

  String _buildReferenceCode(String rawId) {
    final int suffix = 1000 + rawId.hashCode.abs() % 9000;
    return 'KD-$suffix';
  }
}
