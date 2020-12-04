#!/bin/sh

numb='2987'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --no-asm --slow-firstpass --weightb --aq-strength 2.5 --ipratio 1.2 --pbratio 1.0 --psy-rd 1.0 --qblur 0.6 --qcomp 0.9 --vbv-init 0.7 --aq-mode 2 --b-adapt 2 --bframes 10 --crf 45 --keyint 240 --lookahead-threads 1 --min-keyint 27 --qp 30 --qpstep 4 --qpmin 3 --qpmax 66 --rc-lookahead 18 --ref 4 --vbv-bufsize 2000 --deblock 1:1 --me hex --overscan show --preset ultrafast --scenecut 40 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,--no-asm,--slow-firstpass,--weightb,2.5,1.2,1.0,1.0,0.6,0.9,0.7,2,2,10,45,240,1,27,30,4,3,66,18,4,2000,1:1,hex,show,ultrafast,40,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"