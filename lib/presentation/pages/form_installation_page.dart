part of 'pages.dart';

class FormInstallationPage extends StatefulWidget {
  const FormInstallationPage({super.key});

  @override
  State<FormInstallationPage> createState() => _FormInstallationPageState();
}

class _FormInstallationPageState extends State<FormInstallationPage> {
  @override
  void initState() {
    super.initState();
    // Mengirim event untuk memulai pengambilan data dari CategoryItemBloc
    context.read<CategoryItemBloc>().add(const FetchCategoryItems());
  }

  final documentations = <XFile>[].obs;

  Future<bool> _requestPermission(Permission permission) async {
    final status = await permission.request();
    return status.isGranted;
  }

  pickImagesFromGallery() async {
    //Meminta Izin akses ke galeri
    if (await _requestPermission(Permission.storage)) {
      List<XFile>? results = await ImagePicker().pickMultiImage();
      if (results.isNotEmpty) {
        documentations.addAll(results);
      }
    } else {
      if (mounted) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Akses Galeri Ditolak'),
              content: const Text(
                  'Akses ke galeri tidak diizinkan. Anda perlu memberikan izin untuk mengakses galeri.'),
              actions: <Widget>[
                TextButton(
                  child: const Text('Tutup'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      }
    }
  }

  //Fungsi Untuk Mengahapus Gambar
  void removeImage(int index) {
    documentations.removeAt(index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget.secondary('Detail Ticket', context),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 24),
              physics: const BouncingScrollPhysics(),
              children: [
                contentTicketDMS(),
                const Gap(24),
                // contentTicketDMS(),
                formInstallation(),
              ],
            ),
          )
        ],
      ),
      bottomNavigationBar: Container(
        height: 50,
        decoration: BoxDecoration(
            color: AppColor.whiteColor,
            borderRadius: BorderRadius.circular(10),
            boxShadow: const [
              BoxShadow(
                  offset: Offset(0, 3),
                  blurRadius: 10,
                  blurStyle: BlurStyle.outer)
            ]),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 50,
              vertical: 5,
            ),
            child: DButtonFlat(
              onClick: () {
                Navigator.pushNamed(context, AppRoute.dashboard);
              },
              radius: 10,
              mainColor: AppColor.blueColor1,
              child: const Text(
                'Submit',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget contentTicketDMS() {
    final edtServicePoint = TextEditingController(text: 'Serpo Batam 1');
    final edtProject = TextEditingController(text: 'B2JS');
    final edtSegment =
        TextEditingController(text: 'TRIAS_Tanjung Bemban - Tanjung Pinggir');
    final edtSection = TextEditingController(
        text: 'TRIAS_Diversity Tanjung Pinggir - Batam Center');
    final edtWorker = TextEditingController(
        text: 'TRIAS_Diversity Tanjung Pinggir - Batam Center');
    final edtArea = TextEditingController(text: 'West 1');
    final edtLatitude = TextEditingController(text: '-6.225678');
    final edtLongtitude = TextEditingController(text: '106.873981');
    return Container(
      decoration: BoxDecoration(
        color: AppColor.whiteColor,
        borderRadius: BorderRadius.circular(5),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'TT-24082800S009',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColor.defaultText,
            ),
          ),
          Divider(
            color: AppColor.greyColor2,
          ),
          InputWidget.disable(
            'Service Point',
            edtServicePoint,
          ),
          const Gap(6),
          InputWidget.disable(
            'Project',
            edtProject,
          ),
          const Gap(6),
          InputWidget.disable(
            'Segment',
            edtSegment,
          ),
          const Gap(6),
          InputWidget.disable(
            'Section Name',
            edtSection,
          ),
          const Gap(6),
          InputWidget.disable(
            'Worker',
            edtWorker,
          ),
          const Gap(6),
          InputWidget.disable(
            'Area',
            edtArea,
          ),
          const Gap(6),
          InputWidget.disable(
            'Latitude',
            edtLatitude,
          ),
          const Gap(6),
          InputWidget.disable(
            'Longitude',
            edtLongtitude,
          ),
          const Gap(6),
        ],
      ),
    );
  }

  Widget formInstallation() {
    String? selectedValue;
    final edtDescription = TextEditingController();
    return BlocBuilder<CategoryItemBloc, CategoryItemState>(
        builder: (context, state) {
      if (state is CategoryItemLoading) {
        return const Center(child: CircularProgressIndicator());
      } else if (state is CategoryItemFailed) {
        return Center(child: Text(state.message));
      } else if (state is CategoryItemLoaded) {
        List<String> typeOfCables = state.categoryItems
            .map((item) => item.cableType ?? '')
            .where((type) => type.isNotEmpty)
            .toSet() // Remove duplicates
            .toList();

        List<String> categoryOfInstallation = state.categoryItems
            .map((item) => item.categoryItem ?? '')
            .where((type) => type.isNotEmpty)
            .toSet() // Remove duplicates
            .toList();

        List<String> categoryOfInstallationDetails = state.categoryItems
            .map((item) => item.item ?? '')
            .where((type) => type.isNotEmpty)
            .toSet() // Remove duplicates
            .toList();
        return Container(
          decoration: BoxDecoration(
            color: AppColor.whiteColor,
            borderRadius: BorderRadius.circular(5),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Form Installation',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColor.defaultText,
                ),
              ),
              Divider(
                color: AppColor.greyColor2,
              ),
              InputWidget.dropDown2(
                'Type of cable/enviroment installation',
                "Select Type Of Cable",
                selectedValue,
                typeOfCables,
                (newValue) {
                  setState(() {
                    selectedValue = newValue;
                  });
                },
                'Search type cable/environment installation',
              ),
              InputWidget.dropDown2(
                'Category of installation',
                "Select Category of installation",
                selectedValue,
                categoryOfInstallation,
                (newValue) {
                  setState(() {
                    selectedValue = newValue;
                  });
                },
                'Search category of installation',
              ),
              const Gap(6),
              InputWidget.dropDown2(
                'Category of installation Details',
                "Select Category of installation Details",
                selectedValue,
                categoryOfInstallationDetails,
                (newValue) {
                  setState(() {
                    selectedValue = newValue;
                  });
                },
                'Search category of installation',
              ),           
              const Gap(6),
              InputWidget.textArea(
                'Description',
                'Description',
                edtDescription,
              ),
              const Gap(6),
              uploadFile('Documentation/Photo', 'Upload'),
              const Gap(12),
            ],
          ),
        );
      } else {
        return const Center(
          child: FailedUI(message: 'Error Fetch Data Gagal',),
        );
      }
    });
  }

  Widget uploadFile(String title, String textButton) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
        const Gap(3),
        Container(
          height: 300,
          decoration: BoxDecoration(
            color: AppColor.whiteColor,
            border: Border.all(color: AppColor.defaultText),
            borderRadius: BorderRadius.circular(5),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Obx(() {
                // Jika tidak ada gambar yang dipilih, tampilkan teks 'No Image Selected'
                if (documentations.isEmpty) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        'No Image Selected',
                        style: TextStyle(
                          color: AppColor.defaultText,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const Gap(20),
                      // Tampilkan tombol upload menggunakan showModalBottomSheet
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 36),
                        child: DButtonFlat(
                          onClick: () {
                            pickImagesFromGallery();
                          },
                          height: 40,
                          mainColor: AppColor.blueColor1,
                          radius: 10,
                          child: Text(
                            textButton,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                } else {
                  // Jika ada gambar yang dipilih, tampilkan dalam GridView
                  return Expanded(
                    child: GridView.builder(
                      padding: const EdgeInsets.fromLTRB(12, 12, 24, 12),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3, // Atur jumlah kolom yang diinginkan
                        crossAxisSpacing: 8.0,
                        mainAxisSpacing: 8.0,
                      ),
                      itemCount: documentations.length +
                          1, // Tambahkan 1 untuk tombol tambah
                      itemBuilder: (context, index) {
                        if (index == documentations.length) {
                          // Tombol '+' untuk menambahkan gambar
                          return GestureDetector(
                            onTap: () {
                              pickImagesFromGallery();
                            },
                            child: Container(
                              width: 79,
                              height: 68,
                              decoration: BoxDecoration(
                                border: Border.all(color: AppColor.defaultText),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Icon(
                                Icons.add,
                                color: AppColor.defaultText,
                              ),
                            ),
                          );
                        }

                        String path = documentations[index].path;
                        return Stack(
                          children: [
                            // Tampilkan gambar yang dipilih
                            GestureDetector(
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (_) => Dialog(
                                    child: Image.file(
                                      File(path),
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                );
                              },
                              child: SizedBox(
                                width: 79,
                                height: 68,
                                child: Image.file(
                                  File(path),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Positioned(
                              left: 0,
                              top: 0,
                              child: GestureDetector(
                                onTap: () => removeImage(index),
                                child: Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: AppColor.closeButton,
                                  ),
                                  child: const Icon(
                                    Icons.close,
                                    color: Colors.white,
                                    size: 16,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  );
                }
              }),
            ],
          ),
        ),
      ],
    );
  }
}
