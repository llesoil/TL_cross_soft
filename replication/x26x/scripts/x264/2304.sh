#!/bin/sh

numb='2305'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --weightb --aq-strength 3.0 --ipratio 1.4 --pbratio 1.2 --psy-rd 0.4 --qblur 0.4 --qcomp 0.6 --vbv-init 0.1 --aq-mode 3 --b-adapt 1 --bframes 2 --crf 40 --keyint 220 --lookahead-threads 3 --min-keyint 20 --qp 30 --qpstep 4 --qpmin 4 --qpmax 68 --rc-lookahead 38 --ref 4 --vbv-bufsize 2000 --deblock 1:1 --me hex --overscan crop --preset slow --scenecut 0 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,None,None,--weightb,3.0,1.4,1.2,0.4,0.4,0.6,0.1,3,1,2,40,220,3,20,30,4,4,68,38,4,2000,1:1,hex,crop,slow,0,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"