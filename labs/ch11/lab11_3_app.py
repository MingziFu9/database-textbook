"""实验 11-3：Streamlit 版“小店管理助手”。运行：streamlit run lab11_3_app.py"""
import streamlit as st

import shop_service as svc

st.set_page_config(page_title="小店管理助手", page_icon="🛒")
st.title("🛒 社区小店管理助手")
page = st.sidebar.radio("功能", ["查商品", "录订单", "看报表"])

if page == "查商品":
    kw = st.text_input("商品名称关键字", "牛奶")
    st.dataframe(svc.search_products(kw), hide_index=True)
    st.subheader("库存不足 10 件的商品")
    st.dataframe(svc.low_stock(10), hide_index=True)

elif page == "录订单":
    customer_id = st.number_input("顾客编号", min_value=1, value=1)
    employee_id = st.number_input("收银员编号", min_value=1, value=3)
    product_id = st.number_input("商品编号", min_value=1, value=8)
    qty = st.number_input("数量", min_value=1, value=1)
    if st.button("提交订单"):
        try:
            oid = svc.place_order(int(customer_id), int(employee_id),
                                  [(int(product_id), int(qty))])
            st.success(f"下单成功，订单号 {oid}")
        except Exception as e:                     # 库存不够、编号不存在等都会到这里
            st.error(f"下单失败，已回滚：{e}")

else:
    df = svc.monthly_sales()
    st.metric("最近一个月销售额", f"{df['销售额'].iloc[-1]:,.2f} 元")
    st.bar_chart(df, x="月份", y="销售额")
    st.dataframe(df, hide_index=True)
