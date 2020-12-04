#!/bin/sh

numb='813'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --constrained-intra --no-asm --slow-firstpass --weightb --aq-strength 0.5 --ipratio 1.4 --pbratio 1.2 --psy-rd 1.6 --qblur 0.4 --qcomp 0.6 --vbv-init 0.7 --aq-mode 2 --b-adapt 2 --bframes 4 --crf 30 --keyint 300 --lookahead-threads 3 --min-keyint 25 --qp 20 --qpstep 3 --qpmin 3 --qpmax 65 --rc-lookahead 38 --ref 3 --vbv-bufsize 2000 --deblock 1:1 --me umh --overscan show --preset veryslow --scenecut 0 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,--no-asm,--slow-firstpass,--weightb,0.5,1.4,1.2,1.6,0.4,0.6,0.7,2,2,4,30,300,3,25,20,3,3,65,38,3,2000,1:1,umh,show,veryslow,0,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"