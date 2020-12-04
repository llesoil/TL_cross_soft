#!/bin/sh

numb='564'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --constrained-intra --no-asm --weightb --aq-strength 1.0 --ipratio 1.3 --pbratio 1.1 --psy-rd 1.8 --qblur 0.6 --qcomp 0.7 --vbv-init 0.0 --aq-mode 2 --b-adapt 1 --bframes 12 --crf 10 --keyint 270 --lookahead-threads 4 --min-keyint 27 --qp 20 --qpstep 3 --qpmin 1 --qpmax 62 --rc-lookahead 48 --ref 3 --vbv-bufsize 2000 --deblock -1:-1 --me dia --overscan show --preset veryslow --scenecut 10 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,--no-asm,None,--weightb,1.0,1.3,1.1,1.8,0.6,0.7,0.0,2,1,12,10,270,4,27,20,3,1,62,48,3,2000,-1:-1,dia,show,veryslow,10,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"