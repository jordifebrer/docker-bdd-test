# docker-bdd-test
This project is just an example of how we can run a native GUI browser with docker like Chrome or Firefox and also how we can run BDD test on them, everything from one single Dockerfile. (1 hour project)

Run the test:
```shell
docker build -t behave-example
docker run -e DISPLAY -v $HOME/.Xauthority:/home/developer/.Xauthority --net=host behave-example
```

Run the test on Chrome:
```shell
docker run -e DISPLAY -v $HOME/.Xauthority:/home/developer/.Xauthority --net=host behave-example -D browser=chrome
```

Run the test on Firefox:
```shell
docker run -e DISPLAY -v $HOME/.Xauthority:/home/developer/.Xauthority --net=host behave-example -D browser=firefox
```
