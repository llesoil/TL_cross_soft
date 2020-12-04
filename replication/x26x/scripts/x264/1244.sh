#!/bin/sh

numb='1245'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --no-asm --slow-firstpass --no-weightb --aq-strength 1.5 --ipratio 1.5 --pbratio 1.4 --psy-rd 3.0 --qblur 0.5 --qcomp 0.6 --vbv-init 0.2 --aq-mode 0 --b-adapt 1 --bframes 14 --crf 15 --keyint 220 --lookahead-threads 0 --min-keyint 20 --qp 50 --qpstep 3 --qpmin 2 --qpmax 61 --rc-lookahead 48 --ref 1 --vbv-bufsize 2000 --deblock -2:-2 --me dia --overscan show --preset ultrafast --scenecut 40 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,--no-asm,--slow-firstpass,--no-weightb,1.5,1.5,1.4,3.0,0.5,0.6,0.2,0,1,14,15,220,0,20,50,3,2,61,48,1,2000,-2:-2,dia,show,ultrafast,40,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"