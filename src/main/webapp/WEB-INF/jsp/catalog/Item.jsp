<%--
       Copyright 2010-2022 the original author or authors.

       Licensed under the Apache License, Version 2.0 (the "License");
       you may not use this file except in compliance with the License.
       You may obtain a copy of the License at

          https://www.apache.org/licenses/LICENSE-2.0

       Unless required by applicable law or agreed to in writing, software
       distributed under the License is distributed on an "AS IS" BASIS,
       WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
       See the License for the specific language governing permissions and
       limitations under the License.
--%>
<%@ include file="../common/IncludeTop.jsp"%>

<div id="BackLink">
    <stripes:link beanclass="org.mybatis.jpetstore.web.actions.CatalogActionBean" event="viewProduct">
        <stripes:param name="productId" value="${actionBean.product.productId}" />
        Return to ${actionBean.product.productId}
    </stripes:link>
</div>

<div id="Catalog">

    <div class="item-details">
        <h2>${actionBean.product.name}</h2>
        
        <p class="description">${actionBean.product.description}</p>
        
        <p><strong>Item ID:</strong> ${actionBean.item.itemId}</p>
        
        <p style="font-size: 1.2em; font-weight: bold;">
            ${actionBean.item.attribute1} ${actionBean.item.attribute2} 
            ${actionBean.item.attribute3} ${actionBean.item.attribute4} 
            ${actionBean.item.attribute5} ${actionBean.product.name}
        </p>

        <p>
            <c:choose>
                <c:when test="${actionBean.item.quantity <= 0}">
                    <em>Back ordered.</em>
                </c:when>
                <c:otherwise>
                    ${actionBean.item.quantity} in stock.
                </c:otherwise>
            </c:choose>
        </p>

        <p class="price">
            <fmt:formatNumber value="${actionBean.item.listPrice}" pattern="$#,##0.00" />
        </p>

        <stripes:link class="Button"
            beanclass="org.mybatis.jpetstore.web.actions.CartActionBean"
            event="addItemToCart">
            <stripes:param name="workingItemId" value="${actionBean.item.itemId}" />
            Add to Cart
        </stripes:link>
    </div>

</div>

<%@ include file="../common/IncludeBottom.jsp"%>
