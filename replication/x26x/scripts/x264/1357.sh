#!/bin/sh

numb='1358'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --no-asm --no-weightb --aq-strength 1.0 --ipratio 1.1 --pbratio 1.4 --psy-rd 0.6 --qblur 0.5 --qcomp 0.8 --vbv-init 0.5 --aq-mode 2 --b-adapt 0 --bframes 12 --crf 25 --keyint 290 --lookahead-threads 1 --min-keyint 27 --qp 30 --qpstep 3 --qpmin 0 --qpmax 62 --rc-lookahead 38 --ref 5 --vbv-bufsize 2000 --deblock -1:-1 --me dia --overscan crop --preset veryfast --scenecut 10 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,--no-asm,None,--no-weightb,1.0,1.1,1.4,0.6,0.5,0.8,0.5,2,0,12,25,290,1,27,30,3,0,62,38,5,2000,-1:-1,dia,crop,veryfast,10,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"