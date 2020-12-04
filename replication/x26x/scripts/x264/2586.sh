#!/bin/sh

numb='2587'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --constrained-intra --slow-firstpass --no-weightb --aq-strength 1.0 --ipratio 1.4 --pbratio 1.2 --psy-rd 1.8 --qblur 0.3 --qcomp 0.9 --vbv-init 0.2 --aq-mode 2 --b-adapt 2 --bframes 16 --crf 45 --keyint 250 --lookahead-threads 3 --min-keyint 27 --qp 10 --qpstep 4 --qpmin 0 --qpmax 63 --rc-lookahead 48 --ref 3 --vbv-bufsize 2000 --deblock 1:1 --me umh --overscan crop --preset slow --scenecut 0 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,None,--slow-firstpass,--no-weightb,1.0,1.4,1.2,1.8,0.3,0.9,0.2,2,2,16,45,250,3,27,10,4,0,63,48,3,2000,1:1,umh,crop,slow,0,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"