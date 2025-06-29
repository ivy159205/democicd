# Sử dụng SDK của .NET 8 để build ứng dụng
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /app

# Copy project file để restore dependencies trước
# Đường dẫn: WebApplication1/WebApplication1.csproj từ thư mục gốc của context build (democicd/)
# Destination: WebApplication1/WebApplication1.csproj BÊN TRONG CONTAINER
COPY WebApplication1/WebApplication1.csproj WebApplication1/WebApplication1.csproj
# ^^^^^ Chú ý thay đổi ở đây ^^^^^

# Restore dependencies cho project
# Đường dẫn này là tương đối từ WORKDIR /app
# Chúng ta đã copy nó vào /app/WebApplication1/WebApplication1.csproj
RUN dotnet restore WebApplication1/WebApplication1.csproj
# ^^^^^ Chú ý thay đổi ở đây ^^^^^

# Copy toàn bộ mã nguồn vào thư mục làm việc hiện tại của container
# (tất cả các file và thư mục từ democicd/ sẽ được copy vào /app)
COPY . .

# Xuất bản ứng dụng từ đường dẫn project cụ thể
# Đường dẫn này là tương đối từ WORKDIR /app
RUN dotnet publish WebApplication1/WebApplication1.csproj -c Release -o /app/publish
# ^^^^^ Chú ý thay đổi ở đây ^^^^^

# Giai đoạn cuối cùng: sử dụng runtime của .NET 8 để chạy ứng dụng
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS final
WORKDIR /app
COPY --from=build /app/publish .
ENTRYPOINT ["dotnet", "WebApplication1.dll"]