#!/bin/sh

numb='1501'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --no-asm --slow-firstpass --weightb --aq-strength 1.5 --ipratio 1.6 --pbratio 1.1 --psy-rd 0.4 --qblur 0.4 --qcomp 0.9 --vbv-init 0.6 --aq-mode 2 --b-adapt 0 --bframes 10 --crf 50 --keyint 200 --lookahead-threads 4 --min-keyint 30 --qp 50 --qpstep 5 --qpmin 1 --qpmax 62 --rc-lookahead 28 --ref 2 --vbv-bufsize 2000 --deblock 1:1 --me dia --overscan crop --preset slower --scenecut 0 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,--no-asm,--slow-firstpass,--weightb,1.5,1.6,1.1,0.4,0.4,0.9,0.6,2,0,10,50,200,4,30,50,5,1,62,28,2,2000,1:1,dia,crop,slower,0,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"