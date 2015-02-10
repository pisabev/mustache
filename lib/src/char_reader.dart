part of mustache;

class _CharReader {

  String _source;
  Iterator<int> _itr;
  int _i, _c;
  int _line = 1, _column = 1;

  _CharReader(String source)
      : _source = source,
        _itr = source.runes.iterator {
        
    if (source == null)
      throw new ArgumentError('Source is null.');
    
    _i = 0;
    
    if (source == '') {
    	_c = _EOF;
    } else {
    	_itr.moveNext();
    	_c = _itr.current;
    }
  }
  
  int get line => _line;
  int get column => _column;
  int get offset => _i;
  
  int read() {
    var c = _c;
    if (_itr.moveNext()) {
    	_i++;
    	_c = _itr.current;
    } else {
    	_c = _EOF;
    }

    if (c == _NEWLINE) {
    	_line++;
    	_column = 1;
    } else {
    	_column++;
    }

    return c;
  }
  
  int peek() => _c;
  
  String readWhile(bool test(int charCode)) {
    
    //FIXME provide template name. Or perhaps this is a programmer error
    // and this shouldn't actually happen.
    if (peek() == _EOF)
      throw new _TemplateException(
          'Unexpected end of input', null, null, 0);
    
    int start = _i;
    
    while (peek() != _EOF && test(peek())) {
      read();
    }
    
    int end = peek() == _EOF ? _source.length : _i;
    return _source.substring(start, end);
  }
}