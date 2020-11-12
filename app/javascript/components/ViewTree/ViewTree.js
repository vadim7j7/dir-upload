import React, { useMemo, useState, useCallback } from 'react';
import Table from 'antd/es/table';
import Spin from 'antd/es/spin';

import Download from '../Download';

const columns = [
  {
    title: 'Name',
    dataIndex: 'title',
    key: 'title',
    render: (title, { isLeaf, url }) => {
      if (isLeaf) {
        return <a href={url} target="_blank">{title}</a>;
      }
      return title
    }
  },
  {
    title: 'Size',
    dataIndex: 'meta',
    render: ({ size }, { isLeaf }) => {
      const suf = isLeaf ? '' : ` document${size === 1 ? '' : 's'} `;
      return `${(size ? `${size}${suf}` : '-')}`
    },
  }
]

const ViewTree = () => {
  const [loading, setLoading] = useState(true);
  const [data, setData] = useState([]);
  const [checkedKeys, setCheckedKeys] = useState([]);

  const check = useCallback(keys => {
    setCheckedKeys(keys);
  }, [data]);

  const loadData = useCallback(() => {
    fetch('/api/directories')
      .then(response => response.json())
      .then(({ data }) => {
        setData(data);
        setLoading(false);
      })
  }, []);

  useMemo(() => {
    loadData();
    setInterval(() => {
      loadData();
    }, 2000);
  }, []);

  return (
    <div className="view-tree">
      <Download
        disabled={!checkedKeys || checkedKeys.length === 0}
        keys={checkedKeys}
      />

      {loading ? (
        <div style={{ textAlign: 'center' }}>
          <Spin size="large" />
        </div>
      ) : (
        <Table
          expandable={{
            defaultExpandAllRows: true,
          }}
          rowSelection={{
            selectedRowKeys: checkedKeys,
            onChange: check
          }}
          columns={columns}
          dataSource={data}
        />
      )}
    </div>
  );
}

export default ViewTree;
