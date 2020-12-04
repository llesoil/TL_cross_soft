#!/bin/sh

numb='2764'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --constrained-intra --no-asm --slow-firstpass --weightb --aq-strength 2.5 --ipratio 1.5 --pbratio 1.3 --psy-rd 4.6 --qblur 0.2 --qcomp 0.6 --vbv-init 0.8 --aq-mode 2 --b-adapt 0 --bframes 14 --crf 15 --keyint 210 --lookahead-threads 0 --min-keyint 28 --qp 20 --qpstep 3 --qpmin 3 --qpmax 68 --rc-lookahead 38 --ref 1 --vbv-bufsize 1000 --deblock -1:-1 --me umh --overscan show --preset veryslow --scenecut 30 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,--no-asm,--slow-firstpass,--weightb,2.5,1.5,1.3,4.6,0.2,0.6,0.8,2,0,14,15,210,0,28,20,3,3,68,38,1,1000,-1:-1,umh,show,veryslow,30,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"