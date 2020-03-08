Rails.application.routes.draw do
  devise_for :users, controllers: {
    registrations: 'users/registrations',
    sessions: 'users/sessions'
  }

  root "emboss#index" # 打刻画面
  resources :home, only: [:index] # ホーム画面（各ページへのリンクが存在）
  resources :emboss, only: [:index, :create] # 勤怠打刻
  resources :mytimes, only: [:index, :show] # 自分の勤怠を確認
  resources :fix_time, only: [:index, :edit, :update] # 勤怠修正
end
