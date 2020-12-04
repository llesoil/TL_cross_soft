#!/bin/sh

numb='704'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --slow-firstpass --no-weightb --aq-strength 1.5 --ipratio 1.6 --pbratio 1.3 --psy-rd 2.6 --qblur 0.5 --qcomp 0.9 --vbv-init 0.6 --aq-mode 0 --b-adapt 0 --bframes 10 --crf 0 --keyint 270 --lookahead-threads 1 --min-keyint 27 --qp 40 --qpstep 4 --qpmin 4 --qpmax 61 --rc-lookahead 18 --ref 5 --vbv-bufsize 2000 --deblock -2:-2 --me umh --overscan show --preset placebo --scenecut 0 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,None,--slow-firstpass,--no-weightb,1.5,1.6,1.3,2.6,0.5,0.9,0.6,0,0,10,0,270,1,27,40,4,4,61,18,5,2000,-2:-2,umh,show,placebo,0,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"