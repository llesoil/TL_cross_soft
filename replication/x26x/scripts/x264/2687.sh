#!/bin/sh

numb='2688'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --constrained-intra --no-asm --weightb --aq-strength 0.5 --ipratio 1.4 --pbratio 1.1 --psy-rd 3.6 --qblur 0.4 --qcomp 0.6 --vbv-init 0.2 --aq-mode 1 --b-adapt 2 --bframes 8 --crf 40 --keyint 270 --lookahead-threads 2 --min-keyint 24 --qp 20 --qpstep 5 --qpmin 4 --qpmax 65 --rc-lookahead 28 --ref 1 --vbv-bufsize 2000 --deblock 1:1 --me umh --overscan show --preset veryslow --scenecut 30 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,--no-asm,None,--weightb,0.5,1.4,1.1,3.6,0.4,0.6,0.2,1,2,8,40,270,2,24,20,5,4,65,28,1,2000,1:1,umh,show,veryslow,30,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"