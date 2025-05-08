from fastapi import FastAPI, Request, Form, Depends
from fastapi.staticfiles import StaticFiles
from fastapi.templating import Jinja2Templates
from fastapi.responses import HTMLResponse, RedirectResponse
from fastapi.middleware.cors import CORSMiddleware
from sqlalchemy.orm import Session
import os
import models
from .database import engine, get_db
from .routes import router
from . import auth
from pathlib import Path


from fastapi.templating import Jinja2Templates

BASE_DIR = Path(__file__).resolve().parent
templates = Jinja2Templates(directory=str(BASE_DIR / "templates"))

# Create database tables
models.Base.metadata.create_all(bind=engine)

app = FastAPI(title="SkyJourney API" , debug=True)

# Add CORS middleware
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # In production, replace with specific origins
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Mount static files directory
# Get absolute path
static_dir = Path(__file__).parent / "static"

# Mount static directory
app.mount("/static", StaticFiles(directory=str(static_dir)), name="static")

# Include API routes
app.include_router(router, prefix="/api")


# Frontend routes
@app.get("/", response_class=HTMLResponse)
async def home(request: Request):
    return templates.TemplateResponse("home.html", {"request": request})

@app.get("/login", response_class=HTMLResponse)
async def login_page(request: Request):
    return templates.TemplateResponse("login.html", {"request": request})

@app.post("/login")
async def login_submit(request: Request, email: str = Form(...), password: str = Form(...), db: Session = Depends(get_db)):
    user = auth.authenticate_user(db, email, password)
    if not user:
        return templates.TemplateResponse("login.html", {"request": request, "error": "Invalid credentials"})
    
    access_token = auth.create_access_token(data={"sub": user.email})
    response = RedirectResponse(url="/", status_code=303)
    response.set_cookie(key="access_token", value=f"Bearer {access_token}", httponly=True)
    return response

@app.get("/signup", response_class=HTMLResponse)
async def signup_page(request: Request):
    return templates.TemplateResponse("signup.html", {"request": request})

@app.post("/signup")
async def signup_submit(request: Request, email: str = Form(...), password: str = Form(...), db: Session = Depends(get_db)):
    db_user = auth.get_user(db, email=email)
    if db_user:
        return templates.TemplateResponse("signup.html", {"request": request, "error": "Email already registered"})
    
    hashed_password = auth.get_password_hash(password)
    db_user = models.User(email=email, hashed_password=hashed_password)
    db.add(db_user)
    db.commit()
    db.refresh(db_user)
    
    return RedirectResponse(url="/login", status_code=303)

@app.get("/mybooking", response_class=HTMLResponse)
async def my_booking(request: Request):
    return templates.TemplateResponse("mybooking.html", {"request": request})

@app.get("/review", response_class=HTMLResponse)
async def review(request: Request):
    return templates.TemplateResponse("review.html", {"request": request})

@app.get("/test")
def test():
    return {"message": "Server is working"}


if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)