#!/bin/sh

numb='2226'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --constrained-intra --no-asm --slow-firstpass --weightb --aq-strength 1.0 --ipratio 1.1 --pbratio 1.0 --psy-rd 4.2 --qblur 0.6 --qcomp 0.9 --vbv-init 0.1 --aq-mode 1 --b-adapt 2 --bframes 12 --crf 0 --keyint 280 --lookahead-threads 0 --min-keyint 22 --qp 40 --qpstep 4 --qpmin 3 --qpmax 65 --rc-lookahead 18 --ref 4 --vbv-bufsize 2000 --deblock -2:-2 --me umh --overscan crop --preset placebo --scenecut 0 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,--no-asm,--slow-firstpass,--weightb,1.0,1.1,1.0,4.2,0.6,0.9,0.1,1,2,12,0,280,0,22,40,4,3,65,18,4,2000,-2:-2,umh,crop,placebo,0,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"