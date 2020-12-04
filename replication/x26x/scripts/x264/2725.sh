#!/bin/sh

numb='2726'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --constrained-intra --no-asm --slow-firstpass --no-weightb --aq-strength 0.0 --ipratio 1.0 --pbratio 1.3 --psy-rd 3.6 --qblur 0.2 --qcomp 0.7 --vbv-init 0.4 --aq-mode 0 --b-adapt 2 --bframes 6 --crf 50 --keyint 250 --lookahead-threads 4 --min-keyint 27 --qp 0 --qpstep 5 --qpmin 0 --qpmax 66 --rc-lookahead 48 --ref 4 --vbv-bufsize 2000 --deblock -2:-2 --me dia --overscan show --preset medium --scenecut 40 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,--no-asm,--slow-firstpass,--no-weightb,0.0,1.0,1.3,3.6,0.2,0.7,0.4,0,2,6,50,250,4,27,0,5,0,66,48,4,2000,-2:-2,dia,show,medium,40,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"