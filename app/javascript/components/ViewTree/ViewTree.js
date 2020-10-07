import React, { useMemo, useState, useCallback } from 'react';
import Tree from 'antd/es/tree';
import Spin from 'antd/es/spin';

const TreeItem = ({ data: { title, url } }) => (
  url ? <a target="_blank" href={url}>{title}</a> : title
);

const ViewTree = () => {
  const [loading, setLoading] = useState(true);
  const [treeData, setTreeData] = useState([]);
  const [checkedKeys, setCheckedKeys] = useState([]);

  const select = useCallback((_, { node: { url } }) => {
    if (!url) {
      return;
    }

    window.open(url, '_blank');
  }, []);

  const loadData = useCallback(() => {
    fetch('/api/directories')
      .then(response => response.json())
      .then(({ data }) => {
        setTreeData(data);
        setLoading(false);
      })
  }, []);

  const check = useCallback(keys => {
    setCheckedKeys(keys);
    console.log(keys);
  }, [treeData]);

  useMemo(() => {
    loadData();
    setInterval(() => {
      loadData();
    }, 2000);
  }, []);

  return (
    <div className="view-tree">
      {loading ? (
        <div style={{ textAlign: 'center' }}>
          <Spin size="large" />
        </div>
      ) : (
        <Tree
          showLine
          checkable
          defaultExpandAll
          checkedKeys={checkedKeys}
          treeData={treeData}
          titleRender={item => <TreeItem data={item} />}
          onSelect={select}
          onCheck={check}
        />
      )}
    </div>
  );
};

export default ViewTree
