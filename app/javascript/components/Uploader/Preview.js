import React from 'react';

const Item = ({ file }) => (
  <li>
    {file.path} - {file.size} bytes
  </li>
);

const Preview = ({ files }) => (
  <div className="preview">
    <h4>Files</h4>
    <ul>
      {files.map(file => (
        <Item key={file.path} file={file} />
      ))}
    </ul>
  </div>
);

export default Preview;
