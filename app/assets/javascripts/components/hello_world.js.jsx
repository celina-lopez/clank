function HelloWorld(props) {
  return (
    <div>
      Greeting: {props.greeting}
    </div>
  );
}

HelloWorld.propTypes = {
  greeting: PropTypes.string
};


