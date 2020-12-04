#!/bin/sh

numb='2171'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --constrained-intra --no-asm --slow-firstpass --weightb --aq-strength 0.0 --ipratio 1.5 --pbratio 1.2 --psy-rd 1.8 --qblur 0.2 --qcomp 0.6 --vbv-init 0.4 --aq-mode 2 --b-adapt 2 --bframes 8 --crf 45 --keyint 220 --lookahead-threads 0 --min-keyint 20 --qp 10 --qpstep 3 --qpmin 3 --qpmax 69 --rc-lookahead 18 --ref 5 --vbv-bufsize 1000 --deblock -2:-2 --me umh --overscan show --preset slow --scenecut 40 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,--no-asm,--slow-firstpass,--weightb,0.0,1.5,1.2,1.8,0.2,0.6,0.4,2,2,8,45,220,0,20,10,3,3,69,18,5,1000,-2:-2,umh,show,slow,40,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"