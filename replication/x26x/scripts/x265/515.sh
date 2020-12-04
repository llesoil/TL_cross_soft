#!/bin/sh

numb='516'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --constrained-intra --no-asm --slow-firstpass --weightb --aq-strength 0.5 --ipratio 1.6 --pbratio 1.4 --psy-rd 3.2 --qblur 0.6 --qcomp 0.8 --vbv-init 0.9 --aq-mode 2 --b-adapt 2 --bframes 2 --crf 50 --keyint 220 --lookahead-threads 4 --min-keyint 20 --qp 20 --qpstep 4 --qpmin 0 --qpmax 63 --rc-lookahead 48 --ref 6 --vbv-bufsize 1000 --deblock -2:-2 --me umh --overscan crop --preset placebo --scenecut 0 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,--no-asm,--slow-firstpass,--weightb,0.5,1.6,1.4,3.2,0.6,0.8,0.9,2,2,2,50,220,4,20,20,4,0,63,48,6,1000,-2:-2,umh,crop,placebo,0,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"