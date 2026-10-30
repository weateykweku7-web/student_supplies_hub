import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ProductDetailScreen extends StatelessWidget {
  final Map<String, dynamic> product;

  const ProductDetailScreen({Key? key, required this.product}) : super(key: key);

  // Function to launch WhatsApp with a pre-filled order message
  Future<void> _launchWhatsApp(BuildContext context, String phone, String title, dynamic price) async {
    // Clean phone number format for international link (ensuring Ghana country code is preserved)
    final formattedPhone = phone.startsWith('+') ? phone.substring(1) : phone;
    
    final message = Uri.encodeComponent(
      "Hello! I am interested in buying *${title}* listed for *GH₵ ${price}* on Student Supplies Hub. Is it still available?"
    );
    
    final url = "https://wa.me/$formattedPhone?text=$message";
    
    try {
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not open WhatsApp. Please check your connection.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error launching WhatsApp: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final title = product['title'] ?? 'Student Supply Item';
    final price = product['price'] ?? '0.00';
    final description = product['description'] ?? 'No additional description provided for this item.';
    final vendorName = product['vendorName'] ?? 'Local Bookshop';
    final vendorPhone = product['vendorPhone'] ?? '233553688108';

    return Scaffold(
      backgroundColor: const Color(0xFF121212), // Deep charcoal black background
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E1E1E),
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          title,
          style: const TextStyle(
            color: Color(0xFFE0E0E0),
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      body: Column(
        children: [
          // Expanded Image Display Header
          Container(
            height: 250,
            width: double.infinity,
            color: Colors.grey[850],
            child: const Center(
              child: Icon(
                Icons.book_outlined,
                size: 80,
                color: Colors.white54,
              ),
            ),
          ),
          
          // Product Content Section
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(20.0),
              decoration: const BoxDecoration(
                color: Color(0xFF1E1E1E),
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title and Price Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'GH₵ $price',
                        style: const TextStyle(
                          color: Color(0xFF00C853), // Emerald green accent
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Vendor Badge Info
                  Row(
                    children: [
                      const Icon(Icons.store, size: 16, color: Colors.grey),
                      const SizedBox(width: 6),
                      Text(
                        'Sold by: $vendorName',
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  const Divider(color: Colors.white24, height: 24),

                  // Description Header
                  const Text(
                    'Item Description',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  
                  // Description Body
                  Text(
                    description,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                      height: 1.4,
                    ),
                  ),
                  const Spacer(),

                  // WhatsApp Order Action Button
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF00C853), // Emerald green WhatsApp-themed CTA
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () => _launchWhatsApp(context, vendorPhone, title, price),
                      icon: const Icon(Icons.chat, color: Colors.black),
                      label: const Text(
                        'Order via WhatsApp',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
