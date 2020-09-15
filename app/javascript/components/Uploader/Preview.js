import React from 'react';

const Progress = ({ progress }) => {
  if (progress === null) {
    return null;
  }

  return (
    <span>
      {progress === 100 ? ' (Uploaded)' : ` (${progress}%)`}
    </span>
  );
}

const Item = ({ item }) => (
  <li>
    {item.file.path} - {item.file.size} bytes
    {' '}
    <Progress progress={item.uploadProgress}/>
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
