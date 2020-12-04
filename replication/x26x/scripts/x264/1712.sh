#!/bin/sh

numb='1713'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --constrained-intra --no-asm --weightb --aq-strength 0.0 --ipratio 1.6 --pbratio 1.2 --psy-rd 0.2 --qblur 0.3 --qcomp 0.8 --vbv-init 0.3 --aq-mode 1 --b-adapt 0 --bframes 8 --crf 5 --keyint 210 --lookahead-threads 2 --min-keyint 28 --qp 20 --qpstep 4 --qpmin 1 --qpmax 63 --rc-lookahead 18 --ref 6 --vbv-bufsize 2000 --deblock 1:1 --me umh --overscan show --preset superfast --scenecut 40 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,--no-asm,None,--weightb,0.0,1.6,1.2,0.2,0.3,0.8,0.3,1,0,8,5,210,2,28,20,4,1,63,18,6,2000,1:1,umh,show,superfast,40,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"