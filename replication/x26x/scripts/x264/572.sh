#!/bin/sh

numb='573'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --constrained-intra --no-asm --slow-firstpass --weightb --aq-strength 1.0 --ipratio 1.4 --pbratio 1.1 --psy-rd 4.0 --qblur 0.3 --qcomp 0.9 --vbv-init 0.6 --aq-mode 1 --b-adapt 1 --bframes 4 --crf 40 --keyint 200 --lookahead-threads 3 --min-keyint 28 --qp 20 --qpstep 4 --qpmin 0 --qpmax 63 --rc-lookahead 48 --ref 4 --vbv-bufsize 2000 --deblock -2:-2 --me hex --overscan show --preset veryslow --scenecut 30 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,--no-asm,--slow-firstpass,--weightb,1.0,1.4,1.1,4.0,0.3,0.9,0.6,1,1,4,40,200,3,28,20,4,0,63,48,4,2000,-2:-2,hex,show,veryslow,30,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"