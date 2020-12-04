#!/bin/sh

numb='709'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --no-asm --no-weightb --aq-strength 1.0 --ipratio 1.3 --pbratio 1.4 --psy-rd 1.2 --qblur 0.5 --qcomp 0.9 --vbv-init 0.3 --aq-mode 2 --b-adapt 0 --bframes 2 --crf 50 --keyint 250 --lookahead-threads 2 --min-keyint 29 --qp 0 --qpstep 5 --qpmin 3 --qpmax 60 --rc-lookahead 48 --ref 3 --vbv-bufsize 2000 --deblock -1:-1 --me hex --overscan show --preset slower --scenecut 0 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,--no-asm,None,--no-weightb,1.0,1.3,1.4,1.2,0.5,0.9,0.3,2,0,2,50,250,2,29,0,5,3,60,48,3,2000,-1:-1,hex,show,slower,0,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"