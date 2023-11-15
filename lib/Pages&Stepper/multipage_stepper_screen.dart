import 'package:flutter/material.dart';
import 'package:uhcd_childreen_project/Pages&Stepper/page_widget/education_info.dart';
import 'package:uhcd_childreen_project/Pages&Stepper/page_widget/extracaculam_info.dart';
import 'package:uhcd_childreen_project/Pages&Stepper/page_widget/financial_info.dart';
import 'package:uhcd_childreen_project/Pages&Stepper/page_widget/job_info.dart';
import 'package:uhcd_childreen_project/Pages&Stepper/page_widget/others_info.dart';
import 'package:uhcd_childreen_project/Pages&Stepper/page_widget/personal_info.dart';

class SignUpWizard extends StatefulWidget {
  @override
  _SignUpWizardState createState() => _SignUpWizardState();
}

class _SignUpWizardState extends State<SignUpWizard> {
  final PageController _pageController = PageController();
  final ScrollController _scrollController = ScrollController();
  int _currentPage = 0;

  List<Widget> _pages = [
    PersonalInfoPage(),
    EducationalInfoPage(),
    JobInfoPage(),
    FinancialInfoPage(),
    ExtracurricularInfoPage(),
    OthersInfoPage(),
  ];

  List<String> _pageNames = [
    'Personal Info',
    'Educational Info',
    'Job Info',
    'Financial Info',
    'Extracurricular Info',
    'Others Info',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Information Wizard'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              controller: _scrollController,
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  _pages.length,
                      (index) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: InkWell(
                      onTap: () {
                        _pageController.animateToPage(
                          index,
                          duration: Duration(milliseconds: 500),
                          curve: Curves.ease,
                        );
                      },
                      child: Container(
                        color: _currentPage == index
                            ? Colors.blue // Indicator color for the current page
                            : Colors.grey,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            _pageNames[index], // Display the page name
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: PageView(
              controller: _pageController,
              physics: NeverScrollableScrollPhysics(), // Disable sliding
              onPageChanged: (int page) {
                setState(() {
                  _currentPage = page;
                  _scrollToSelectedPage();
                });
              },
              children: _pages,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: _currentPage == 0
                  ? MainAxisAlignment.end
                  : MainAxisAlignment.spaceBetween,
              children: [
                if (_currentPage > 0)
                  ElevatedButton(
                    onPressed: () {
                      _pageController.previousPage(
                        duration: Duration(milliseconds: 500),
                        curve: Curves.ease,
                      );
                    },
                    child: Text('Previous'),
                  ),
                ElevatedButton(
                  onPressed: () {
                    if (_currentPage < _pages.length - 1) {
                      _pageController.nextPage(
                        duration: Duration(milliseconds: 500),
                        curve: Curves.ease,
                      );
                    } else {
                      // Handle Save button action for the last page
                      // e.g., validate and save data
                      print('Save button pressed!');
                    }
                  },
                  child: Text(_currentPage < _pages.length - 1 ? 'Next' : 'Save'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _scrollToSelectedPage() {
    double scrollOffset = _scrollController.position.maxScrollExtent /
        (_pageNames.length - 1) *
        _currentPage;
    _scrollController.animateTo(
      scrollOffset,
      duration: Duration(milliseconds: 500),
      curve: Curves.ease,
    );
  }
}
