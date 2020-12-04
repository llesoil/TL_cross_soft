#!/bin/sh

numb='2350'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --constrained-intra --no-asm --slow-firstpass --no-weightb --aq-strength 0.0 --ipratio 1.3 --pbratio 1.0 --psy-rd 3.0 --qblur 0.3 --qcomp 0.6 --vbv-init 0.3 --aq-mode 1 --b-adapt 1 --bframes 0 --crf 0 --keyint 250 --lookahead-threads 4 --min-keyint 29 --qp 0 --qpstep 4 --qpmin 0 --qpmax 62 --rc-lookahead 48 --ref 4 --vbv-bufsize 1000 --deblock 1:1 --me umh --overscan show --preset medium --scenecut 30 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,--no-asm,--slow-firstpass,--no-weightb,0.0,1.3,1.0,3.0,0.3,0.6,0.3,1,1,0,0,250,4,29,0,4,0,62,48,4,1000,1:1,umh,show,medium,30,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"