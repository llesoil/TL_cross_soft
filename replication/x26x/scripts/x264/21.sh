#!/bin/sh

numb='22'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --no-asm --weightb --aq-strength 2.0 --ipratio 1.3 --pbratio 1.2 --psy-rd 1.4 --qblur 0.4 --qcomp 0.7 --vbv-init 0.9 --aq-mode 0 --b-adapt 2 --bframes 0 --crf 15 --keyint 270 --lookahead-threads 2 --min-keyint 21 --qp 50 --qpstep 4 --qpmin 3 --qpmax 60 --rc-lookahead 48 --ref 2 --vbv-bufsize 1000 --deblock -1:-1 --me hex --overscan crop --preset fast --scenecut 40 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,--no-asm,None,--weightb,2.0,1.3,1.2,1.4,0.4,0.7,0.9,0,2,0,15,270,2,21,50,4,3,60,48,2,1000,-1:-1,hex,crop,fast,40,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"