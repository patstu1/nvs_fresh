import 'package:flutter/material.dart';
import 'package:nvs/meatup_core.dart';

// Placeholder model for a user photo
class UserPhoto {
  UserPhoto({required this.id, required this.url});
  final String id;
  final String url;
}

class PhotoManager extends StatefulWidget {
  const PhotoManager({super.key});

  @override
  State<PhotoManager> createState() => _PhotoManagerState();
}

class _PhotoManagerState extends State<PhotoManager> {
  // Mock data for our photo gallery
  final List<UserPhoto> _photos = <UserPhoto>[
    UserPhoto(
        id: '1',
        url:
            'https://source.unsplash.com/random/400x400?portrait,man,cinematic,1',),
    UserPhoto(
        id: '2',
        url:
            'https://source.unsplash.com/random/400x400?portrait,man,cinematic,2',),
    UserPhoto(
        id: '3',
        url:
            'https://source.unsplash.com/random/400x400?portrait,man,cinematic,3',),
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300, // Give our manager a defined space
      child: ReorderableListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _photos.length + 1, // +1 for the "Add" button
        itemBuilder: (BuildContext context, int index) {
          if (index == _photos.length) {
            // This is our "Add Photo" button
            return _buildAddPhotoTile();
          }
          // This is a regular photo tile
          return _buildPhotoTile(_photos[index]);
        },
        onReorder: (int oldIndex, int newIndex) {
          setState(() {
            if (newIndex > oldIndex) newIndex -= 1;
            // Prevent reordering the "Add" button
            if (newIndex >= _photos.length) return;

            final UserPhoto item = _photos.removeAt(oldIndex);
            _photos.insert(newIndex, item);
          });
        },
      ),
    );
  }

  Widget _buildPhotoTile(UserPhoto photo) {
    return Container(
      key: ValueKey(photo.id),
      width: 200,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          // The Image
          ClipRRect(
            borderRadius: BorderRadius.circular(4), // A very subtle rounding
            child: Image.network(photo.url, fit: BoxFit.cover),
          ),
          // The "Delete" button
          Positioned(
            top: 4,
            right: 4,
            child: InkWell(
              onTap: () {/* TODO: Implement delete photo logic */},
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  color: Colors.black54,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.close, color: Colors.white, size: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddPhotoTile() {
    return InkWell(
      key: const ValueKey('add_photo'),
      onTap: () {/* TODO: Implement image picker logic */},
      child: Container(
        width: 200,
        margin: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          border: Border.all(color: NVSColors.dividerColor, width: 1.5),
          borderRadius: BorderRadius.circular(4),
        ),
        child: const Center(
          child: Icon(Icons.add, color: NVSColors.secondaryText, size: 48),
        ),
      ),
    );
  }
}
