// Flutter code sample for BottomNavigationBar

// This example shows a [BottomNavigationBar] as it is used within a [Scaffold]
// widget. The [BottomNavigationBar] has three [BottomNavigationBarItem]
// widgets and the [currentIndex] is set to index 0. The selected item is
// amber. The `_onItemTapped` function changes the selected item's index
// and displays a corresponding message in the center of the [Scaffold].
//
// ![A scaffold with a bottom navigation bar containing three bottom navigation
// bar items. The first one is selected.](https://flutter.github.io/assets-for-api-docs/assets/material/bottom_navigation_bar.png)

import 'package:flutter/material.dart';
import 'package:hello_world/bloc/bloc.dart';
import 'package:hello_world/repositories/repositories.dart';
import 'package:http/http.dart' as http;
import 'package:bloc/bloc.dart';
import 'package:provider/provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hello_world/bloc/settings_bloc.dart';
import 'package:video_player/video_player.dart';
import 'dart:developer';
import 'package:chewie/chewie.dart';
import 'package:chewie/src/chewie_player.dart';


void main() {
  log("where am I");
  print("wtf");
  runApp(
    Provider(
      create: (_) => new LotRepository(lotApiClient: LotApiClient('http://127.0.0.1:8080', httpClient: http.Client())),
      child: MyApp(),
    ),
  );
}

//void main() => runApp(MyApp());

/// This Widget is the main application widget.
class MyApp extends StatelessWidget {
  static const String _title = 'Flutter Code Sample';

  MyApp();

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => SettingsBloc(Provider.of<LotRepository>(context, listen: false))),
        BlocProvider(create: (context) => SeriesBloc(Provider.of<LotRepository>(context, listen: false))),
        BlocProvider(create: (context) => MoviesBloc(Provider.of<LotRepository>(context, listen: false)))
        ],
      child: MaterialApp(
        title: _title,
        home: MyStatefulWidget(),
      )
    );
  }
}
  
class MyStatefulWidget extends StatefulWidget {
  MyStatefulWidget({Key key}) : super(key: key);

  @override
  _MyStatefulWidgetState createState() => _MyStatefulWidgetState();
}

class SettingsWidget extends StatelessWidget {

  final TextEditingController _textController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsBloc, SettingsState>(
      builder: (context, state) {
        var text = Text('something is wrong');
        if (state is SettingsLoaded) {
          text = Text('Settings loaded niceee');
        }
        if (state is SettingsNotLoaded) {
          text = Text('Settings not loaded');
        }
        if (state is SettingsLoading) {
          text = Text('replace me with loading thing');
        }
        return Column(children: [ 
          text,
          Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center, 
              children: <Widget>[
                TextField(
                  controller: _textController,
                  decoration: const InputDecoration(
                    hintText: 'Enter API Host',
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: RaisedButton(
                    onPressed: () {
                      print("hello");
                      print(_textController.value.text);
                      try {
                      Provider.of<SettingsBloc>(context).add(SetHost(_textController.value.text));
                      } catch (e) {
                        print(e);
                      }
                      print("jello");
                    },
                    child: Text('Submit'),
                  ),
                ),
             ],
           ),
        ]);
      }
    );
  }
}

class EpisodesWidget extends StatelessWidget {

  const EpisodesWidget();

  @override
  Widget build(BuildContext context) {
    
    return BlocBuilder<SeriesBloc, SeriesState>(
      builder: (context, state) {
        print(state.runtimeType.toString());
        if (state is SeriesLoading) {
          return CircularProgressIndicator();
        } else if (state is SeriesLoaded) {
          List<Widget> list = new List<Widget>();
          for (var i = 0; i < state.episodes.length; i++) {
            list.add(
              Row(children:[
                RaisedButton(child: Text("Series: " + state.episodes[i].series),
                  onPressed: () {
                    var id = state.episodes[i].id;
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ChewieDemo(url: "http://127.0.0.1:8080/episodes/${id}")),
                    ).then((thing) => print(thing));
                  },
                )
              ]
            ));
          }
          return Column(children: list);
        } else if (state is SeriesInit) {
          BlocProvider.of<SeriesBloc>(context).add(FetchSeries());
        }

        return Text('no sereies');
        // return widget here based on BlocA's state
      }
    );
  }
}

class MoviessWidget extends StatelessWidget {

  const MoviessWidget();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MoviesBloc, MoviesState>(
      builder: (context, state) {
        print(state.runtimeType.toString());
        if (state is MoviesLoading) {
          return CircularProgressIndicator();
        } else if (state is MoviesLoaded) {
          List<Widget> list = new List<Widget>();
          for (var i = 0; i < state.movies.length; i++) {
            list.add(
              Row(children:[
                RaisedButton(child: Text("Series: " + state.movies[i].title),
                  onPressed: () {
                    var id = state.movies[i].id;
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ChewieDemo(url: "http://127.0.0.1:8080/movies/${id}")),
                    ).then((thing) => print(thing));
                  },
                )
              ]
            ));
          }
          return Column(children: list);
        } else if (state is MoviesInit) {
          BlocProvider.of<MoviesBloc>(context).add(FetchMovies());
        }

        return Text('no sereies');
        // return widget here based on BlocA's state
      }
    );
  }
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static final _formKey = GlobalKey<FormState>();
  static List<Widget> _widgetOptions = <Widget>[
    MoviessWidget(),
    EpisodesWidget(),
    SettingsWidget()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lot'),
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.movie),
            title: Text('Movies'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.live_tv),
            title: Text('Series'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            title: Text('Settings'),
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }
}









class VideoApp extends StatefulWidget {
  @override
  _VideoAppState createState() => _VideoAppState();
}

class _VideoAppState extends State<VideoApp> {
  VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    print("initilaizing video player state");
    _controller = VideoPlayerController.network(
        'http://127.0.0.1:8080/movies/Tc0uXWA3j0y8soJzYkqB9')
      ..initialize().then((_) {
        print("Player is initialized-----------------");
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
      }, onError: (err) {
        print("There was an error");
         print(err);
      });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Video Demo',
      home: Scaffold(
        body: Center(
          child: _controller.value.initialized
              ? AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  child: VideoPlayer(_controller),
                )
              : CircularProgressIndicator(),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            print("I've been pressed");
            setState(() {
              _controller.value.isPlaying
                  ? _controller.pause()
                  : _controller.play();
            });
          },
          child: Icon(
            _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}


















class ChewieDemo extends StatefulWidget {
  ChewieDemo({this.title = 'Chewie Demo', @required this.url});

  final String url;
  final String title;

  @override
  State<StatefulWidget> createState() {
    return _ChewieDemoState();
  }
}

class _ChewieDemoState extends State<ChewieDemo> {
  TargetPlatform _platform;
  VideoPlayerController _videoPlayerController;
  ChewieController _chewieController;

  @override
  void initState() {
    super.initState();
    _videoPlayerController = VideoPlayerController.network(this.widget.url);
    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      aspectRatio: 3 / 2,
      autoPlay: true,
      looping: true,
      // Try playing around with some of these other options:

      // showControls: false,
      // materialProgressColors: ChewieProgressColors(
      //   playedColor: Colors.red,
      //   handleColor: Colors.blue,
      //   backgroundColor: Colors.grey,
      //   bufferedColor: Colors.lightGreen,
      // ),
      // placeholder: Container(
      //   color: Colors.grey,
      // ),
      // autoInitialize: true,
    );
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: widget.title,
      theme: ThemeData.light().copyWith(
        platform: _platform ?? Theme.of(context).platform,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Column(
          children: <Widget>[
            Expanded(
              child: Center(
                child: Chewie(
                  controller: _chewieController,
                ),
              ),
            ),
            FlatButton(
              onPressed: () {
                _chewieController.enterFullScreen();
              },
              child: Text('Fullscreen'),
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: FlatButton(
                    onPressed: () {
                      setState(() {
                        _platform = TargetPlatform.android;
                      });
                    },
                    child: Padding(
                      child: Text("Android controls"),
                      padding: EdgeInsets.symmetric(vertical: 16.0),
                    ),
                  ),
                ),
                Expanded(
                  child: FlatButton(
                    onPressed: () {
                      setState(() {
                        _platform = TargetPlatform.iOS;
                      });
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 16.0),
                      child: Text("iOS controls"),
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}