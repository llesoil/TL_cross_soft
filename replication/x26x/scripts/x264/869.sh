#!/bin/sh

numb='870'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --no-asm --slow-firstpass --no-weightb --aq-strength 2.0 --ipratio 1.5 --pbratio 1.4 --psy-rd 1.2 --qblur 0.5 --qcomp 0.7 --vbv-init 0.8 --aq-mode 1 --b-adapt 2 --bframes 8 --crf 45 --keyint 300 --lookahead-threads 1 --min-keyint 22 --qp 50 --qpstep 5 --qpmin 4 --qpmax 62 --rc-lookahead 48 --ref 5 --vbv-bufsize 2000 --deblock -2:-2 --me umh --overscan show --preset slow --scenecut 30 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,--no-asm,--slow-firstpass,--no-weightb,2.0,1.5,1.4,1.2,0.5,0.7,0.8,1,2,8,45,300,1,22,50,5,4,62,48,5,2000,-2:-2,umh,show,slow,30,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"