#!/bin/sh

numb='2863'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --no-asm --weightb --aq-strength 2.5 --ipratio 1.0 --pbratio 1.2 --psy-rd 2.0 --qblur 0.5 --qcomp 0.9 --vbv-init 0.2 --aq-mode 2 --b-adapt 2 --bframes 8 --crf 40 --keyint 220 --lookahead-threads 2 --min-keyint 21 --qp 10 --qpstep 4 --qpmin 1 --qpmax 65 --rc-lookahead 48 --ref 2 --vbv-bufsize 2000 --deblock -2:-2 --me dia --overscan show --preset superfast --scenecut 40 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,--no-asm,None,--weightb,2.5,1.0,1.2,2.0,0.5,0.9,0.2,2,2,8,40,220,2,21,10,4,1,65,48,2,2000,-2:-2,dia,show,superfast,40,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"