var maria = require('../lib/mysql-promised.js')
// mysql.user doesn't have a nice identifier field so we use a SHA1 of the username and hostname
const id = 'SHA1(CONCAT(a.user, a.host))'
const query = 'SELECT ' + id + ' AS id, a.* FROM mysql.user AS a'


exports.type = 'users'

function doRequest(q, param) {
    return maria.query(q, param)
        .then((res) => {
            return Promise.all(res.map((r) => {
                return maria.query(QUERY, [r.User, r.Host])
                    .then((tab_res) => r.tables_priv = tab_res)
                    .then(() => maria.query(QUERY, [r.User, r.Host]))
                    .then((col_res) => r.columns_priv = col_res)
            }))
                .then(() => res)
        })
}

exports.collection = () => {
    return doRequest(query)
}

exports.resource = (resource) => {
    return doRequest(query + ' WHERE ' + id + ' = ? LIMIT 1', [resource])
}
