#!/bin/sh

numb='2803'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --no-asm --weightb --aq-strength 1.0 --ipratio 1.3 --pbratio 1.1 --psy-rd 2.8 --qblur 0.5 --qcomp 0.9 --vbv-init 0.9 --aq-mode 0 --b-adapt 2 --bframes 6 --crf 40 --keyint 250 --lookahead-threads 1 --min-keyint 24 --qp 30 --qpstep 4 --qpmin 3 --qpmax 64 --rc-lookahead 38 --ref 3 --vbv-bufsize 1000 --deblock -1:-1 --me dia --overscan crop --preset veryslow --scenecut 30 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,--no-asm,None,--weightb,1.0,1.3,1.1,2.8,0.5,0.9,0.9,0,2,6,40,250,1,24,30,4,3,64,38,3,1000,-1:-1,dia,crop,veryslow,30,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"