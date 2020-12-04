#!/bin/sh

numb='53'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --no-weightb --aq-strength 2.5 --ipratio 1.1 --pbratio 1.4 --psy-rd 2.8 --qblur 0.6 --qcomp 0.8 --vbv-init 0.8 --aq-mode 0 --b-adapt 2 --bframes 0 --crf 20 --keyint 250 --lookahead-threads 3 --min-keyint 24 --qp 50 --qpstep 5 --qpmin 4 --qpmax 68 --rc-lookahead 38 --ref 4 --vbv-bufsize 2000 --deblock -1:-1 --me dia --overscan crop --preset fast --scenecut 0 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,None,None,--no-weightb,2.5,1.1,1.4,2.8,0.6,0.8,0.8,0,2,0,20,250,3,24,50,5,4,68,38,4,2000,-1:-1,dia,crop,fast,0,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"