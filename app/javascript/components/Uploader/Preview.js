import React from 'react';
import Progress from 'antd/es/progress';

const Item = ({ item }) => (
  <li>
    {item.file.path} - {item.file.size} bytes
    {' '}
    {item.uploadProgress === null ? null : (
      <Progress percent={item.uploadProgress} />
    )}
  </li>
)

const Preview = ({ items }) => (
  <div className="preview">
    <h4>Files</h4>
    <ul>
      {items.map(item => (
        <Item key={item.file.path} item={item} />
      ))}
    </ul>
  </div>
);

export default Preview;
